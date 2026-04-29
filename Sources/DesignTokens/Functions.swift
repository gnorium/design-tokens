#if SERVER
  import CSSBuilder
  import CSSOMBuilder
  import Foundation
  import WebTypes
  import EmbeddedSwiftUtilities

  // https://developer.apple.com/design/human-interface-guidelines/color
  // https://doc.wikimedia.org/codex/latest/design-tokens/color.html
  // https://doc.wikimedia.org/codex/latest/style-guide/colors.html
  // https://meta.wikimedia.org/wiki/Brand/colours

  // MARK: - Typography Tokens
  @CSSBuilder
  public func TypographyTokensCSS(config: TypographyConfig) -> [CSSRule] {
    customProperty("--typography-font-sans", config.fontSans)
    customProperty("--typography-font-sans-italic", config.fontSansItalic)
    customProperty("--typography-font-serif", config.fontSerif)
    customProperty("--typography-font-serif-italic", config.fontSerifItalic)
    customProperty("--typography-font-mono", config.fontMono)
  }

  // MARK: - Color Tokens - Light Mode
  @CSSBuilder
  public func ColorTokensLightModeCSS() -> [CSSRule] {
    colorScheme(.light).important()

    customProperty("--extreme", .black)
    customProperty("--extreme-inverted", .white)
    customProperty("--mix-blend-mode-blend", .multiply)

    // Fill Tokens (Solid & Subtle Group) - Light Mode
    customProperty("--fill-l", perc(60))
    customProperty("--fill-l-offset", perc(37)) // 60 + 37 = 97 (Subtle L)
    customProperty("--fill-l-hover", perc(55))
    customProperty("--fill-l-active", perc(50))
    customProperty("--fill-c-scale", 1.0)
    customProperty("--fill-c-mult", 0.4) // Subtle chroma is 40% of solid
    customProperty("--glyph-l-hover-offset", perc(-10))
    customProperty("--glyph-l-active-offset", perc(-20))
  }

  // MARK: - Color Tokens - Dark Mode
  @CSSBuilder
  public func ColorTokensDarkModeCSS() -> [CSSRule] {
    colorScheme(.dark).important()

    customProperty("--extreme", .white)
    customProperty("--extreme-inverted", .black)
    customProperty("--mix-blend-mode-blend", .screen)

    // Fill Tokens (Solid & Subtle Group) - Dark Mode
    customProperty("--fill-l", perc(45))
    customProperty("--fill-l-offset", perc(-23)) // 45 - 23 = 22 (Subtle L)
    customProperty("--fill-l-hover", perc(50))
    customProperty("--fill-l-active", perc(55))
    customProperty("--fill-c-scale", 1.0)
    customProperty("--fill-c-mult", 0.4)
    customProperty("--glyph-l-hover-offset", perc(10))
    customProperty("--glyph-l-active-offset", perc(20))
  }

  // MARK: - Parametric Fill Overloads
  public func fillColor(c: Double, h: Double, l: CSSValue? = nil, isSubtle: Bool = false) -> CSSColor {
    fillColor(c: c, h: CSSValue("\(h)"), l: l, isSubtle: isSubtle)
  }

  public func fillColor(c: Double, h: CSSValue, l: Percentage, isSubtle: Bool = false) -> CSSColor {
    fillColor(c: c, h: h, l: CSSValue(l), isSubtle: isSubtle)
  }

  public func fillColor(c: Double, h: CSSValue, l: CSSValue? = nil, isSubtle: Bool = false) -> CSSColor {
    let baseL: CSSValue = l ?? `var`("--fill-l")
    let finalL = isSubtle ? CSSValue(calc(baseL + `var`("--fill-l-offset"))) : baseL
    
    let scale: CSSValue = `var`("--fill-c-scale")
    let mult: CSSValue = `var`("--fill-c-mult")
    let cScale = isSubtle ? CSSValue(calc(scale * mult)) : scale
    
    return oklch(l: finalL, c: CSSValue(calc(c * cScale)), h: h)
  }

  public enum ColorState {
    case hover
    case active
    case selected
    case deep // For 40% shifts
  }

  public func stateColor(_ base: CSSColor, state: ColorState) -> CSSColor {
    let activeOffset: Percentage = `var`("--glyph-l-active-offset")
    let finalOffset: CSSValue

    switch state {
    case .hover: finalOffset = `var`("--glyph-l-hover-offset")
    case .active: finalOffset = CSSValue(activeOffset)
    case .selected: finalOffset = CSSValue(activeOffset)
    case .deep: finalOffset = CSSValue(calc(activeOffset * 2))
    }

    return oklch(from: base, l: CSSValue(calc("l + \(finalOffset)")), c: .custom("c"), h: .custom("h"))
  }

  // MARK: - sRGB Gamut Computation

  /// Convert OKLCH to linear sRGB.
  private func oklchToLinearSRGB(_ l: Double, _ c: Double, _ h: Double) -> (
    r: Double, g: Double, b: Double
  ) {
    let hRad = h * .pi / 180
    let a = c * cos(hRad)
    let b = c * sin(hRad)
    let l_ = l + 0.3963377774 * a + 0.2158037573 * b
    let m_ = l - 0.1055613458 * a - 0.0638541728 * b
    let s_ = l - 0.0894841775 * a - 1.2914855480 * b
    let lc = l_ * l_ * l_
    let mc = m_ * m_ * m_
    let sc = s_ * s_ * s_
    return (
      r: +4.0767416621 * lc - 3.3077115913 * mc + 0.2309699292 * sc,
      g: -1.2684380046 * lc + 2.6097574011 * mc - 0.3413193965 * sc,
      b: -0.0041960863 * lc - 0.7034186147 * mc + 1.7076147010 * sc
    )
  }

  /// Maximum OKLCH chroma within sRGB gamut at given lightness and hue (binary search).
  public func srgbMaxChroma(l: Double, h: Double) -> Double {
    let eps = 1e-7
    var lo = 0.0
    var hi = 0.5
    while hi - lo > eps {
      let mid = (lo + hi) / 2
      let rgb = oklchToLinearSRGB(l, mid, h)
      if rgb.r >= -eps && rgb.r <= 1 + eps && rgb.g >= -eps && rgb.g <= 1 + eps && rgb.b >= -eps
        && rgb.b <= 1 + eps
      {
        lo = mid
      } else {
        hi = mid
      }
    }
    return lo
  }

  /// Absolute sRGB gamut peak for a given hue: the (L, C) with maximum chroma across all lightness values.
  public func srgbGamutPeak(h: Double) -> (l: Double, c: Double) {
    var bestL = 0.0
    var bestC = 0.0
    for i in 0...10000 {
      let l = Double(i) / 10000
      let c = srgbMaxChroma(l: l, h: h)
      if c > bestC {
        bestC = c
        bestL = l
      }
    }
    return (bestL, bestC)
  }

  // MARK: - OKLCH Hue Tokens
  // Apple HIG system colors (Default, light mode), converted to OKLCH.
  // 12 hues (Apple HIG order): red, orange, yellow, green, mint, teal, cyan, blue, indigo, purple, pink, brown.
  // Glyph = Fill for now. Gray is near-achromatic.

  @CSSBuilder
  public func HueTokensCSS() -> [CSSRule] {
    // Hue angles (Apple HIG system colors, OKLCH)
    customProperty("--hue-red", 25.74)
    customProperty("--hue-orange", 55.72)
    customProperty("--hue-yellow", 90.38)
    customProperty("--hue-green", 147.44)
    customProperty("--hue-mint", 181.77)
    customProperty("--hue-teal", 203.30)
    customProperty("--hue-cyan", 219.96)
    customProperty("--hue-blue", 254.09)
    customProperty("--hue-indigo", 279.31)
    customProperty("--hue-purple", 322.51)
    customProperty("--hue-pink", 17.90)
    customProperty("--hue-brown", 57.23)
    customProperty("--hue-gray", 260)

    // Gray: near-achromatic with slight blue tint
    customProperty("--gray-glyph", oklch(l: 0.55, c: 0.015, h: hueGray))
    customProperty("--gray-fill", oklch(l: 0.65, c: 0.015, h: hueGray))

    // Traffic Lights (macOS style)
    customProperty("--traffic-light-red", oklch(l: 0.6776, c: 0.1655, h: 23.38))
    customProperty("--traffic-light-yellow", oklch(l: 0.8509, c: 0.152, h: 91.79))
    customProperty("--traffic-light-green", oklch(l: 0.7399, c: 0.159, h: 143.96))
  }

  @CSSBuilder
  public func SourceTokensLightModeLessContrastCSS() -> [CSSRule] {
    // Fill (surface hierarchy)
    customProperty("--fill", .white)
    customProperty("--fill-alpha", rgba(120, 120, 128, 0.2))
    customProperty("--fill-secondary", oklch(0.98, 0.004, 260))
    customProperty("--fill-tertiary", oklch(0.97, 0.002, 260))
    customProperty("--fill-tertiary-alpha", rgba(118, 118, 128, 0.12))
    customProperty("--fill-gray", oklch(0.20, 0.003, 260))
    customProperty("--fill-gray-alpha", rgba(0, 0, 0, 0.88))
    customProperty("--fill-gray-hover", oklch(0.26, 0.003, 260))
    customProperty("--fill-gray-active", oklch(0.16, 0.003, 260))
    customProperty("--fill-gray-secondary", oklch(0.60, 0.005, 260))
    customProperty("--fill-gray-secondary-alpha", rgba(0, 0, 0, 0.48))
    customProperty("--fill-gray-tertiary", oklch(0.86, 0.005, 260))
    customProperty("--fill-gray-tertiary-alpha", rgba(0, 0, 0, 0.16))
    customProperty("--fill-gray-quaternary", oklch(0.94, 0.005, 260))
    customProperty("--fill-gray-quaternary-alpha", rgba(0, 0, 0, 0.08))

    // Glyph (text hierarchy)
    customProperty("--glyph", .black)
    customProperty("--glyph-fixed", .black)
    customProperty("--glyph-gray", oklch(0.20, 0.003, 260))
    customProperty("--glyph-gray-alpha", rgba(0, 0, 0, 0.88))
    customProperty("--glyph-gray-fixed", oklch(0.20, 0.003, 260))
    customProperty("--glyph-gray-secondary", oklch(0.52, 0.003, 260))
    customProperty("--glyph-gray-secondary-alpha", rgba(0, 0, 0, 0.56))
    customProperty("--glyph-gray-secondary-alt", oklch(0.35, 0.003, 260))
    customProperty("--glyph-gray-secondary-alt-alpha", rgba(0, 0, 0, 0.72))
    customProperty("--glyph-gray-tertiary", oklch(0.60, 0.005, 260))
    customProperty("--glyph-gray-tertiary-alpha", rgba(0, 0, 0, 0.48))

    // Semantic bridge for unified applied function
    customProperty("--border-neutral", oklch(0.86, 0.005, 260))
    customProperty("--border-emphasis", oklch(0.20, 0.003, 260))
    customProperty("--border-interactive", oklch(0.20, 0.003, 260))
    customProperty("--shadow-alpha", rgba(0, 0, 0, 0.06))
    customProperty("--backdrop-light", rgba(255, 255, 255, 0.65))
    customProperty("--backdrop-dark", rgba(0, 0, 0, 0.65))

    // Apple HIG Hues (Default Light)
    customProperty("--glyph-red", oklch(0.6532, 0.2328, 25.74))
    customProperty("--glyph-orange", oklch(0.7533, 0.1720, 55.72))
    customProperty("--glyph-yellow", oklch(0.8652, 0.1768, 90.38))
    customProperty("--glyph-green", oklch(0.7303, 0.1944, 147.44))
    customProperty("--glyph-mint", oklch(0.7471, 0.1340, 181.77))
    customProperty("--glyph-teal", oklch(0.7446, 0.1268, 203.30))
    customProperty("--glyph-cyan", oklch(0.7471, 0.1360, 219.96))
    customProperty("--glyph-blue", oklch(0.6321, 0.2018, 254.09))
    customProperty("--glyph-indigo", oklch(0.5595, 0.2296, 279.31))
    customProperty("--glyph-purple", oklch(0.6216, 0.2629, 322.51))
    customProperty("--glyph-pink", oklch(0.6497, 0.2383, 17.90))
    customProperty("--glyph-brown", oklch(0.6329, 0.0727, 57.23))

    customProperty("--fill-red", fillColor(c: 0.2328, h: 25.74))
    customProperty("--fill-orange", fillColor(c: 0.1720, h: 55.72))
    customProperty("--fill-yellow", fillColor(c: 0.1768, h: 90.38))
    customProperty("--fill-green", fillColor(c: 0.1944, h: 147.44))
    customProperty("--fill-mint", fillColor(c: 0.1340, h: 181.77))
    customProperty("--fill-teal", fillColor(c: 0.1268, h: 203.30))
    customProperty("--fill-cyan", fillColor(c: 0.1360, h: 219.96))
    customProperty("--fill-blue", fillColor(c: 0.2018, h: 254.09))
    customProperty("--fill-indigo", fillColor(c: 0.2296, h: 279.31))
    customProperty("--fill-purple", fillColor(c: 0.2629, h: 322.51))
    customProperty("--fill-pink", fillColor(c: 0.2383, h: 17.90))
    customProperty("--fill-brown", fillColor(c: 0.0727, h: 57.23))

    customProperty("--gray-glyph", oklch(0.55, 0.015, 260))
    customProperty("--gray-fill", oklch(0.65, 0.015, 260))

    // MARK: - Apple HIG Syntax Tokens (Light Mode)
    customProperty("--color-syntax-addition", glyphGreen)
    customProperty("--color-syntax-attributes", hex(0x947100))
    customProperty("--color-syntax-characters", hex(0x272AD8))
    customProperty("--color-syntax-comments", hex(0x707F8C))
    customProperty("--color-syntax-deletion", glyphRed)
    customProperty("--color-syntax-documentation-markup", hex(0x506375))
    customProperty("--color-syntax-heading", hex(0xBA2DA2))
    customProperty("--color-syntax-highlighted", rgba(0, 113, 227, 0.2))
    customProperty("--color-syntax-keywords", hex(0xAD3DA4))
    customProperty("--color-syntax-marks", hex(0x000000))
    customProperty("--color-syntax-numbers", hex(0x272AD8))
    customProperty("--color-syntax-other-class-names", hex(0x703DAA))
    customProperty("--color-syntax-other-constants", hex(0x4B21B0))
    customProperty("--color-syntax-other-declarations", hex(0x047CB0))
    customProperty("--color-syntax-other-function-and-method-names", hex(0x4B21B0))
    customProperty("--color-syntax-other-instance-variables-and-globals", hex(0x703DAA))
    customProperty("--color-syntax-other-preprocessor-macros", hex(0x78492A))
    customProperty("--color-syntax-other-type-names", hex(0x703DAA))
    customProperty("--color-syntax-param-internal-name", hex(0x404040))
    customProperty("--color-syntax-plain-text", hex(0x000000))
    customProperty("--color-syntax-preprocessor-statements", hex(0x78492A))
    customProperty("--color-syntax-project-class-names", hex(0x3E8087))
    customProperty("--color-syntax-project-constants", hex(0x2D6469))
    customProperty("--color-syntax-project-function-and-method-names", hex(0x2D6469))
    customProperty("--color-syntax-project-instance-variables-and-globals", hex(0x3E8087))
    customProperty("--color-syntax-project-preprocessor-macros", hex(0x78492A))
    customProperty("--color-syntax-project-type-names", hex(0x3E8087))
    customProperty("--color-syntax-strings", hex(0xD12F1B))
    customProperty("--color-syntax-type-declarations", hex(0x03638C))
    customProperty("--color-syntax-urls", hex(0x1337FF))
  }

  @CSSBuilder
  public func SourceTokensLightModeMoreContrastCSS() -> [CSSRule] {
    // Fill (surface hierarchy — increased contrast)
    customProperty("--fill", .white)
    customProperty("--fill-alpha", rgba(120, 120, 128, 0.24))
    customProperty("--fill-secondary", oklch(0.97, 0.005, 260))
    customProperty("--fill-tertiary", oklch(0.96, 0.003, 260))
    customProperty("--fill-tertiary-alpha", rgba(118, 118, 128, 0.16))
    customProperty("--fill-gray", oklch(0.15, 0.004, 260))
    customProperty("--fill-gray-alpha", rgba(0, 0, 0, 0.92))
    customProperty("--fill-gray-hover", oklch(0.20, 0.004, 260))
    customProperty("--fill-gray-active", oklch(0.12, 0.004, 260))
    customProperty("--fill-gray-secondary", oklch(0.50, 0.006, 260))
    customProperty("--fill-gray-secondary-alpha", rgba(0, 0, 0, 0.56))
    customProperty("--fill-gray-tertiary", oklch(0.80, 0.006, 260))
    customProperty("--fill-gray-tertiary-alpha", rgba(0, 0, 0, 0.2))
    customProperty("--fill-gray-quaternary", oklch(0.88, 0.006, 260))
    customProperty("--fill-gray-quaternary-alpha", rgba(0, 0, 0, 0.12))

    // Glyph (text hierarchy — increased contrast)
    customProperty("--glyph", .black)
    customProperty("--glyph-fixed", .black)
    customProperty("--glyph-gray", oklch(0.12, 0.004, 260))
    customProperty("--glyph-gray-alpha", rgba(0, 0, 0, 0.94))
    customProperty("--glyph-gray-fixed", oklch(0.20, 0.003, 260))
    customProperty("--glyph-gray-secondary", oklch(0.42, 0.004, 260))
    customProperty("--glyph-gray-secondary-alpha", rgba(0, 0, 0, 0.64))
    customProperty("--glyph-gray-secondary-alt", oklch(0.28, 0.004, 260))
    customProperty("--glyph-gray-secondary-alt-alpha", rgba(0, 0, 0, 0.8))
    customProperty("--glyph-gray-tertiary", oklch(0.50, 0.006, 260))
    customProperty("--glyph-gray-tertiary-alpha", rgba(0, 0, 0, 0.56))

    // Semantic bridge for unified applied function
    customProperty("--border-neutral", oklch(0.80, 0.006, 260))
    customProperty("--border-emphasis", oklch(0.12, 0.004, 260))
    customProperty("--border-interactive", oklch(0.12, 0.004, 260))
    customProperty("--shadow-alpha", rgba(0, 0, 0, 0.08))
    customProperty("--backdrop-light", rgba(255, 255, 255, 0.65))
    customProperty("--backdrop-dark", rgba(0, 0, 0, 0.65))
 
    // Solid Fill parameters (Light Mode - More Contrast)
    customProperty("--fill-l", perc(50))
    customProperty("--fill-l-hover", perc(45))
    customProperty("--fill-l-active", perc(40))
    customProperty("--fill-l-offset", perc(40)) // Boosted offset for HC
    customProperty("--fill-c-scale", 1.1)
    customProperty("--fill-c-mult", 0.5)

    // Apple HIG Hues (High Contrast Light)
    customProperty("--glyph-red", oklch(0.6094, 0.2359, 16.59))
    customProperty("--glyph-orange", oklch(0.5898, 0.1834, 53.68))
    customProperty("--glyph-yellow", oklch(0.5484, 0.1458, 86.85))
    customProperty("--glyph-green", oklch(0.5186, 0.1495, 147.27))
    customProperty("--glyph-mint", oklch(0.5182, 0.1102, 181.70))
    customProperty("--glyph-teal", oklch(0.5133, 0.1118, 203.24))
    customProperty("--glyph-cyan", oklch(0.5113, 0.1228, 219.90))
    customProperty("--glyph-blue", oklch(0.5147, 0.1691, 254.10))
    customProperty("--glyph-indigo", oklch(0.5152, 0.2158, 279.27))
    customProperty("--glyph-purple", oklch(0.5635, 0.2300, 322.44))
    customProperty("--glyph-pink", oklch(0.5936, 0.2314, 15.89))
    customProperty("--glyph-brown", oklch(0.5684, 0.0653, 55.98))

    customProperty("--fill-red", fillColor(c: 0.2359, h: 16.59))
    customProperty("--fill-orange", fillColor(c: 0.1834, h: 53.68))
    customProperty("--fill-yellow", fillColor(c: 0.1458, h: 86.85))
    customProperty("--fill-green", fillColor(c: 0.1495, h: 147.27))
    customProperty("--fill-mint", fillColor(c: 0.1102, h: 181.70))
    customProperty("--fill-teal", fillColor(c: 0.1118, h: 203.24))
    customProperty("--fill-cyan", fillColor(c: 0.1228, h: 219.90))
    customProperty("--fill-blue", fillColor(c: 0.1691, h: 254.10))
    customProperty("--fill-indigo", fillColor(c: 0.2158, h: 279.27))
    customProperty("--fill-purple", fillColor(c: 0.2300, h: 322.44))
    customProperty("--fill-pink", fillColor(c: 0.2314, h: 15.89))
    customProperty("--fill-brown", fillColor(c: 0.0653, h: 55.98))

    customProperty("--gray-glyph", oklch(0.45, 0.02, 260))
    customProperty("--gray-fill", oklch(0.55, 0.02, 260))
  }

  @CSSBuilder
  public func SourceTokensDarkModeLessContrastCSS() -> [CSSRule] {
    // Fill (surface hierarchy)
    customProperty("--fill", .black)
    customProperty("--fill-alpha", rgba(182, 182, 182, 0.3))
    customProperty("--fill-secondary", oklch(0.15, 0.003, 260))
    customProperty("--fill-tertiary", oklch(0.18, 0.003, 260))
    customProperty("--fill-tertiary-alpha", rgba(118, 118, 128, 0.24))
    customProperty("--fill-quaternary-alpha", rgba(116, 116, 128, 0.25))
    customProperty("--fill-gray", oklch(0.96, 0.003, 260))
    customProperty("--fill-gray-alpha", rgba(255, 255, 255, 0.92))
    customProperty("--fill-gray-hover", oklch(0.92, 0.003, 260))
    customProperty("--fill-gray-active", oklch(0.98, 0.003, 260))
    customProperty("--fill-gray-secondary", oklch(0.50, 0.005, 260))
    customProperty("--fill-gray-secondary-alpha", rgba(255, 255, 255, 0.4))
    customProperty("--fill-gray-tertiary", oklch(0.35, 0.005, 260))
    customProperty("--fill-gray-tertiary-alpha", rgba(255, 255, 255, 0.24))
    customProperty("--fill-gray-quaternary", oklch(0.28, 0.005, 260))
    customProperty("--fill-gray-quaternary-alpha", rgba(255, 255, 255, 0.2))

    // Glyph (text hierarchy)
    customProperty("--glyph", .white)
    customProperty("--glyph-fixed", .black)
    customProperty("--glyph-gray", oklch(0.96, 0.003, 260))
    customProperty("--glyph-gray-alpha", rgba(255, 255, 255, 0.92))
    customProperty("--glyph-gray-fixed", oklch(0.20, 0.003, 260))
    customProperty("--glyph-gray-secondary", oklch(0.62, 0.005, 260))
    customProperty("--glyph-gray-secondary-alpha", rgba(255, 255, 255, 0.56))
    customProperty("--glyph-gray-secondary-alt", oklch(0.85, 0.003, 260))
    customProperty("--glyph-gray-secondary-alt-alpha", rgba(255, 255, 255, 0.8))
    customProperty("--glyph-gray-tertiary", oklch(0.50, 0.005, 260))
    customProperty("--glyph-gray-tertiary-alpha", rgba(255, 255, 255, 0.4))

    // Background Layers
    customProperty("--background-primary", oklch(0.17, 0.003, 260))
    customProperty("--background-layer1", oklch(0.27, 0.004, 260))
    customProperty("--background-layer2", oklch(0.34, 0.005, 260))
    customProperty("--backdrop", rgba(10, 10, 10, 0.8))
    customProperty("--sidebar", oklch(0.20, 0.003, 260))
    customProperty("--separator", oklch(0.28, 0.004, 260))

    // Semantic bridge for unified applied function
    customProperty("--border-neutral", oklch(0.50, 0.005, 260))
    customProperty("--border-emphasis", oklch(0.96, 0.003, 260))
    customProperty("--border-interactive", oklch(0.62, 0.005, 260))
    customProperty("--shadow-alpha", rgba(0, 0, 0, 0.87))
    customProperty("--backdrop-light", rgba(0, 0, 0, 0.65))
    customProperty("--backdrop-dark", rgba(255, 255, 255, 0.65))

    // Apple HIG Hues (Default Dark)
    customProperty("--glyph-red", oklch(0.6577, 0.2317, 16.02))
    customProperty("--glyph-orange", oklch(0.7554, 0.1718, 55.70))
    customProperty("--glyph-yellow", oklch(0.8655, 0.1768, 90.38))
    customProperty("--glyph-green", oklch(0.7410, 0.1915, 147.45))
    customProperty("--glyph-mint", oklch(0.7686, 0.1417, 181.78))
    customProperty("--glyph-teal", oklch(0.7656, 0.1340, 203.32))
    customProperty("--glyph-cyan", oklch(0.7699, 0.1264, 218.49))
    customProperty("--glyph-blue", oklch(0.6416, 0.2014, 254.09))
    customProperty("--glyph-indigo", oklch(0.6413, 0.1928, 274.69))
    customProperty("--glyph-purple", oklch(0.6579, 0.2791, 322.41))
    customProperty("--glyph-pink", oklch(0.6577, 0.2317, 16.02))
    customProperty("--glyph-brown", oklch(0.6681, 0.0743, 59.71))

    customProperty("--fill-red", fillColor(c: 0.2317, h: 16.02))
    customProperty("--fill-orange", fillColor(c: 0.1718, h: 55.70))
    customProperty("--fill-yellow", fillColor(c: 0.1768, h: 90.38))
    customProperty("--fill-green", fillColor(c: 0.1915, h: 147.45))
    customProperty("--fill-mint", fillColor(c: 0.1417, h: 181.78))
    customProperty("--fill-teal", fillColor(c: 0.1340, h: 203.32))
    customProperty("--fill-cyan", fillColor(c: 0.1264, h: 218.49))
    customProperty("--fill-blue", fillColor(c: 0.2014, h: 254.09))
    customProperty("--fill-indigo", fillColor(c: 0.1928, h: 274.69))
    customProperty("--fill-purple", fillColor(c: 0.2791, h: 322.41))
    customProperty("--fill-pink", fillColor(c: 0.2317, h: 16.02))
    customProperty("--fill-brown", fillColor(c: 0.0743, h: 59.71))

    customProperty("--gray-glyph", oklch(0.75, 0.01, 260))
    customProperty("--gray-fill", oklch(0.65, 0.01, 260))

    // MARK: - Apple HIG Syntax Tokens (Dark Mode)
    customProperty("--color-syntax-attributes", hex(0xCC9768))
    customProperty("--color-syntax-characters", hex(0xD9C97C))
    customProperty("--color-syntax-comments", hex(0x7F8C98))
    customProperty("--color-syntax-documentation-markup", hex(0x7F8C98))
    customProperty("--color-syntax-documentation-markup-keywords", hex(0xA3B1BF))
    customProperty("--color-syntax-highlighted", rgba(0, 113, 227, 0.6))
    customProperty("--color-syntax-keywords", hex(0xFF7AB2))
    customProperty("--color-syntax-marks", hex(0xFFFFFF))
    customProperty("--color-syntax-numbers", hex(0xD9C97C))
    customProperty("--color-syntax-other-class-names", hex(0xDABAFF))
    customProperty("--color-syntax-other-constants", hex(0xA7EBDD))
    customProperty("--color-syntax-other-declarations", hex(0x4EB0CC))
    customProperty("--color-syntax-other-function-and-method-names", hex(0xB281EB))
    customProperty("--color-syntax-other-instance-variables-and-globals", hex(0xB281EB))
    customProperty("--color-syntax-other-preprocessor-macros", hex(0xFFA14F))
    customProperty("--color-syntax-other-type-names", hex(0xDABAFF))
    customProperty("--color-syntax-param-internal-name", hex(0xBFBFBF))
    customProperty("--color-syntax-plain-text", hex(0xFFFFFF))
    customProperty("--color-syntax-preprocessor-statements", hex(0xFFA14F))
    customProperty("--color-syntax-project-class-names", hex(0xACF2E4))
    customProperty("--color-syntax-project-constants", hex(0x78C2B3))
    customProperty("--color-syntax-project-function-and-method-names", hex(0x78C2B3))
    customProperty("--color-syntax-project-instance-variables-and-globals", hex(0x78C2B3))
    customProperty("--color-syntax-project-preprocessor-macros", hex(0xFFA14F))
    customProperty("--color-syntax-project-type-names", hex(0xACF2E4))
    customProperty("--color-syntax-strings", hex(0xFF8170))
    customProperty("--color-syntax-type-declarations", hex(0x6BDFFF))
    customProperty("--color-syntax-urls", hex(0x6699FF))
  }

  @CSSBuilder
  public func SourceTokensDarkModeMoreContrastCSS() -> [CSSRule] {
    // Fill (surface hierarchy — increased contrast)
    customProperty("--fill", .black)
    customProperty("--fill-alpha", rgba(182, 182, 182, 0.34))
    customProperty("--fill-secondary", oklch(0.14, 0.004, 260))
    customProperty("--fill-tertiary", oklch(0.17, 0.004, 260))
    customProperty("--fill-tertiary-alpha", rgba(118, 118, 128, 0.28))
    customProperty("--fill-quaternary-alpha", rgba(116, 116, 128, 0.29))
    customProperty("--fill-gray", oklch(0.98, 0.002, 260))
    customProperty("--fill-gray-alpha", rgba(255, 255, 255, 0.96))
    customProperty("--fill-gray-hover", oklch(0.94, 0.002, 260))
    customProperty("--fill-gray-active", oklch(0.99, 0.002, 260))
    customProperty("--fill-gray-secondary", oklch(0.58, 0.006, 260))
    customProperty("--fill-gray-secondary-alpha", rgba(255, 255, 255, 0.48))
    customProperty("--fill-gray-tertiary", oklch(0.40, 0.006, 260))
    customProperty("--fill-gray-tertiary-alpha", rgba(255, 255, 255, 0.28))
    customProperty("--fill-gray-quaternary", oklch(0.32, 0.006, 260))
    customProperty("--fill-gray-quaternary-alpha", rgba(255, 255, 255, 0.24))

    // Glyph (text hierarchy — increased contrast)
    customProperty("--glyph", .white)
    customProperty("--glyph-fixed", .black)
    customProperty("--glyph-gray", oklch(0.98, 0.002, 260))
    customProperty("--glyph-gray-alpha", rgba(255, 255, 255, 0.96))
    customProperty("--glyph-gray-fixed", oklch(0.20, 0.003, 260))
    customProperty("--glyph-gray-secondary", oklch(0.70, 0.005, 260))
    customProperty("--glyph-gray-secondary-alpha", rgba(255, 255, 255, 0.64))
    customProperty("--glyph-gray-secondary-alt", oklch(0.90, 0.003, 260))
    customProperty("--glyph-gray-secondary-alt-alpha", rgba(255, 255, 255, 0.86))
    customProperty("--glyph-gray-tertiary", oklch(0.58, 0.006, 260))
    customProperty("--glyph-gray-tertiary-alpha", rgba(255, 255, 255, 0.48))

    // Background Layers
    customProperty("--background-primary", oklch(0.17, 0.003, 260))
    customProperty("--background-layer1", oklch(0.27, 0.004, 260))
    customProperty("--background-layer2", oklch(0.34, 0.005, 260))
    customProperty("--backdrop", rgba(10, 10, 10, 0.85))
    customProperty("--sidebar", oklch(0.20, 0.003, 260))
    customProperty("--separator", oklch(0.28, 0.004, 260))

    // Semantic bridge for unified applied function
    customProperty("--border-neutral", oklch(0.58, 0.006, 260))
    customProperty("--border-emphasis", oklch(0.98, 0.002, 260))
    customProperty("--border-interactive", oklch(0.70, 0.005, 260))
    customProperty("--shadow-alpha", rgba(0, 0, 0, 0.90))
    customProperty("--backdrop-light", rgba(0, 0, 0, 0.65))
    customProperty("--backdrop-dark", rgba(255, 255, 255, 0.65))

    // Solid Fill parameters (Dark Mode - More Contrast)
    customProperty("--fill-l", perc(55))
    customProperty("--fill-l-hover", perc(60))
    customProperty("--fill-l-active", perc(65))
    customProperty("--fill-l-offset", perc(-30)) // Deeper offset for HC Dark
    customProperty("--fill-c-scale", 1.1)
    customProperty("--fill-c-mult", 0.5)

    // Apple HIG Hues (High Contrast Dark)
    customProperty("--glyph-red", oklch(0.7208, 0.1654, 18.06))
    customProperty("--glyph-orange", oklch(0.7774, 0.1471, 55.72))
    customProperty("--glyph-yellow", oklch(0.8876, 0.1410, 89.28))
    customProperty("--glyph-green", oklch(0.7818, 0.1420, 147.45))
    customProperty("--glyph-mint", oklch(0.8122, 0.1065, 181.77))
    customProperty("--glyph-teal", oklch(0.8066, 0.1287, 203.26))
    customProperty("--glyph-cyan", oklch(0.8091, 0.1068, 219.92))
    customProperty("--glyph-blue", oklch(0.7487, 0.1186, 254.08))
    customProperty("--glyph-indigo", oklch(0.7686, 0.1210, 281.60))
    customProperty("--glyph-purple", oklch(0.7809, 0.1823, 320.04))
    customProperty("--glyph-pink", oklch(0.7775, 0.1553, 350.26))
    customProperty("--glyph-brown", oklch(0.7642, 0.0867, 61.31))

    customProperty("--fill-red", fillColor(c: 0.1654, h: 18.06))
    customProperty("--fill-orange", fillColor(c: 0.1471, h: 55.72))
    customProperty("--fill-yellow", fillColor(c: 0.1410, h: 89.28))
    customProperty("--fill-green", fillColor(c: 0.1420, h: 147.45))
    customProperty("--fill-mint", fillColor(c: 0.1065, h: 181.77))
    customProperty("--fill-teal", fillColor(c: 0.1287, h: 203.26))
    customProperty("--fill-cyan", fillColor(c: 0.1068, h: 219.92))
    customProperty("--fill-blue", fillColor(c: 0.1186, h: 254.08))
    customProperty("--fill-indigo", fillColor(c: 0.1210, h: 281.60))
    customProperty("--fill-purple", fillColor(c: 0.1823, h: 320.04))
    customProperty("--fill-pink", fillColor(c: 0.1553, h: 350.26))
    customProperty("--fill-brown", fillColor(c: 0.0867, h: 61.31))

    customProperty("--gray-glyph", oklch(0.85, 0.005, 260))
    customProperty("--gray-fill", oklch(0.75, 0.005, 260))
  }

  // MARK: - Unified Applied Tokens
  // Single function for all modes. Source tokens + semantic bridge handle light/dark/contrast differences.
  // Hover/active direction: `extreme` (black in light, white in dark).
  // Inverted: `extremeInverted` (white in light, black in dark).
  // Neutral borders/disabled: `borderNeutral`. Emphasized: `borderEmphasis`.
  // Interactive hover/active: `borderInteractive`. Shadows: `shadowAlpha`.
  // Backdrops: `backdropLight`/`backdropDark`.
  @CSSBuilder
  public func AppliedTokensCSS() -> [CSSRule] {
    // MARK: Text / Foreground
    customProperty("--color-base", glyphGray)
    customProperty("--color-base-fixed", glyphGrayFixed)
    customProperty("--color-base-hover", glyphGraySecondary)
    customProperty("--color-emphasized", glyph)
    customProperty("--color-subtle", glyphGraySecondary)
    customProperty("--color-placeholder", glyphGrayTertiary)
    customProperty("--color-disabled", borderNeutral)
    customProperty("--color-disabled-emphasized", borderNeutral)
    customProperty("--color-inverted", fill)
    customProperty("--color-inverted-fixed", .white)
    customProperty("--color-content-added", glyphGreen)
    customProperty("--color-content-removed", glyphRed)
    customProperty("--opacity-base", 1)
    customProperty("--opacity-medium", 0.65)
    customProperty("--opacity-low", 0.3)
    customProperty("--opacity-transparent", 0)
    customProperty("--filter-invert-icon", 0)
    customProperty("--filter-invert-primary-button-icon", 1)
    customProperty("--background-position-base", CSSBackgroundPosition.center)
    customProperty("--background-size-search-figure", .cover)
    customProperty("--z-index-bottom", -100)
    customProperty("--z-index-base", 0)
    customProperty("--z-index-above-content", 1)
    customProperty("--z-index-toolbar", 2)
    customProperty("--z-index-dropdown", 50)
    customProperty("--z-index-sticky", 100)
    customProperty("--z-index-fixed", 200)
    customProperty("--z-index-off-canvas-backdrop", 300)
    customProperty("--z-index-off-canvas", 350)
    customProperty("--z-index-overlay-backdrop", 400)
    customProperty("--z-index-overlay", 450)
    customProperty("--z-index-popover", 700)
    customProperty("--z-index-tooltip", 800)
    customProperty("--z-index-toast-notification", 900)
    customProperty("--z-index-top", 9999)
    customProperty("--z-index-stacking-0", 0)
    customProperty("--z-index-stacking-1", 1)
    customProperty("--z-index-stacking-2", 2)
    customProperty("--z-index-stacking-3", 3)
    customProperty("--box-sizing-base", .borderBox)
    customProperty("--size-0", rem(0))
    customProperty("--size-1", rem(0.0625))
    customProperty("--size-2", rem(0.125))
    customProperty("--size-4", rem(0.25))
    customProperty("--size-8", rem(0.5))
    customProperty("--size-12", rem(0.75))
    customProperty("--size-16", rem(1))
    customProperty("--size-20", rem(1.25))
    customProperty("--size-24", rem(1.5))
    customProperty("--size-32", rem(2))
    customProperty("--size-40", rem(2.5))
    customProperty("--size-44", rem(2.75))
    customProperty("--size-48", rem(3))
    customProperty("--size-64", rem(4))
    customProperty("--size-128", rem(8))
    customProperty("--size-192", rem(12))
    customProperty("--size-256", rem(16))
    customProperty("--size-384", rem(24))
    customProperty("--size-448", rem(28))
    customProperty("--size-512", rem(32))
    customProperty("--size-640", rem(40))
    customProperty("--size-896", rem(56))
    customProperty("--size-viewport-width-full", vw(100))
    customProperty("--size-viewport-height-full", vh(100))
    customProperty("--size-absolute-1", px(1))
    customProperty("--size-absolute-9999", px(9999))
    customProperty("--size-content-min", .minContent)
    customProperty("--size-content-fit", .fitContent)
    customProperty("--size-content-max", .maxContent)
    customProperty("--size-third", perc(33.33))
    customProperty("--size-half", perc(50))
    customProperty("--size-full", perc(100))
    customProperty("--size-double", perc(200))
    customProperty("--size-search-figure", rem(2.5))
    customProperty("--max-width-base", CSSKeyword.None.none)
    customProperty("--max-width-breakpoint-phone-narrow", px(479))  // NEW
    customProperty("--max-width-breakpoint-mobile", px(768))
    customProperty("--max-width-breakpoint-tablet", px(1024))
    customProperty("--max-width-breakpoint-desktop", px(1279))
    customProperty("--max-width-button", rem(28))
    customProperty("--border-style-base", CSSBorder.LineStyle.solid)
    customProperty("--border-style-dashed", CSSBorder.LineStyle.dashed)
    customProperty("--box-shadow-inset-small", (.inset, 0, 0, 0, px(1)))
    customProperty("--box-shadow-inset-medium", (.inset, 0, 0, 0, px(2)))
    customProperty("--box-shadow-inset-medium-vertical", (.inset, 0, -2, 0, 0))
    customProperty("--box-shadow-outset-small", (0, 0, 0, px(1)))
    customProperty("--box-shadow-outset-small-top", (0, px(-1), 0, 0))
    customProperty("--box-shadow-outset-small-bottom", (0, px(1), 0, 0))
    customProperty("--box-shadow-outset-small-start", (px(-1), 0, 0, 0))
    customProperty("--box-shadow-outset-medium-below", (0, px(4), px(4), 0))
    customProperty("--box-shadow-outset-medium-around", (0, 0, px(8), 0))
    customProperty("--box-shadow-outset-large-below", (0, px(4), px(8), 0))
    customProperty("--box-shadow-outset-large-around", (0, 0, px(16), 0))
    customProperty("--box-shadow-color-base", borderNeutral)
    customProperty("--box-shadow-color-inverted", extremeInverted)
    customProperty("--box-shadow-color-alpha-base", shadowAlpha)
    customProperty("--box-shadow-color-transparent", .transparent)
    customProperty("--font-family-base", CSSFontFamily.GenericFamily.GenericComplete.sansSerif)
    customProperty(
      "--font-family-system-sans",
      (
        "\"-apple-system\"", "\"BlinkMacSystemFont\"", "\"Segoe UI\"", "\"Roboto\"", "\"Inter\"",
        "\"Helvetica\"", "\"Arial\"", CSSFontFamily.GenericFamily.GenericComplete.sansSerif
      ))
    customProperty(
      "--font-family-sans--fallback", CSSFontFamily.GenericFamily.GenericComplete.sansSerif)
    customProperty(
      "--font-family-serif",
      (
        "\"Linux Libertine\"", "\"Georgia\"", "\"Times\"", "\"Source Serif 4\"",
        CSSFontFamily.GenericFamily.GenericComplete.serif
      ))
    customProperty(
      "--font-family-serif--fallback", CSSFontFamily.GenericFamily.GenericComplete.serif)
    customProperty(
      "--font-family-monospace",
      (
        "\"Menlo\"", "\"Consolas\"", "\"Liberation Mono\"", "\"Fira Code\"", "\"Courier New\"",
        CSSFontFamily.GenericFamily.GenericComplete.monospace
      ))
    customProperty(
      "--font-family-monospace--fallback", CSSFontFamily.GenericFamily.GenericComplete.monospace)
    customProperty(
      "--font-family-heading-main",
      (
        "\"Linux Libertine\"", "\"Georgia\"", "\"Times\"", "\"Source Serif 4\"",
        CSSFontFamily.GenericFamily.GenericComplete.monospace
      ))
    customProperty("--font-size-x-small-12", rem(0.75))
    customProperty("--font-size-small-14", rem(0.875))
    customProperty("--font-size-medium-16", rem(1))
    customProperty("--font-size-large-18", rem(1.125))
    customProperty("--font-size-x-large-20", rem(1.25))
    customProperty("--font-size-xx-large-24", rem(1.5))
    customProperty("--font-size-xxx-large-28", rem(1.75))
    customProperty("--font-weight-hairline", 100)
    customProperty("--font-weight-light", 300)
    customProperty("--font-weight-normal", 400)
    customProperty("--font-weight-semi-bold", 600)
    customProperty("--font-weight-bold", 700)
    customProperty("--line-height-x-small-20", rem(1.25))
    customProperty("--line-height-small-22", rem(1.375))
    customProperty("--line-height-medium-26", rem(1.625))
    customProperty("--line-height-large-28", rem(1.75))
    customProperty("--line-height-x-large-30", rem(1.875))
    customProperty("--line-height-xx-large-34", rem(2.125))
    customProperty("--line-height-xxx-large-38", rem(2.375))
    customProperty("--line-height-content", 1.625)
    customProperty("--text-decoration-none", CSSKeyword.None.none)
    customProperty("--text-decoration-line-through", .lineThrough)
    customProperty("--text-decoration-underline", .underline)
    customProperty("--text-overflow-clip", .clip)
    customProperty("--text-overflow-ellipsis", .ellipsis)
    customProperty("--tab-size-base", 4)
    customProperty("--transform-checkbox-tick-checked", rotate(deg(45)))
    customProperty("--transform-progress-indicator-spinner-start", rotate(deg(-45)))
    customProperty("--transform-progress-indicator-spinner-end", rotate(deg(315)))
    customProperty("--transition-duration-base", ms(100))
    customProperty("--transition-duration-medium", ms(250))
    customProperty(
      "--transition-property-base", (.backgroundColor, .color, .borderColor, .boxShadow))
    customProperty("--transition-property-fade", .opacity)
    customProperty("--transition-property-icon", CSSSingleTransitionProperty.color)
    customProperty("--transition-property-icon-css-only", .backgroundColor)
    customProperty(
      "--transition-property-toggle-switch-grip", (.backgroundColor, .borderColor, .transform))
    customProperty("--transition-timing-function-system", .ease)
    customProperty("--transition-timing-function-user", .easeOut)
    customProperty("--animation-delay-none", ms(0))
    customProperty("--animation-delay-medium", ms(-160))
    customProperty("--animation-delay-slow", ms(-320))
    customProperty("--animation-duration-fast", ms(1000))
    customProperty("--animation-duration-medium", ms(1600))
    customProperty("--animation-duration-slow", ms(2000))
    customProperty("--animation-timing-function-base", .linear)
    customProperty("--animation-timing-function-bouncing", .easeInOut)
    customProperty("--animation-iteration-count-base", .infinite)
    customProperty("--cursor-base", .default)
    customProperty("--cursor-base-disabled", .default)
    customProperty("--cursor-base-hover", .pointer)
    customProperty("--cursor-grab", .grab)
    customProperty("--cursor-grabbing", .grabbing)
    customProperty("--cursor-help", .help)
    customProperty("--cursor-move", .move)
    customProperty("--cursor-not-allowed", .notAllowed)
    customProperty("--cursor-resize-nesw", .neswResize)
    customProperty("--cursor-resize-nwse", .nwseResize)
    customProperty("--cursor-text", .text)
    customProperty("--cursor-zoom-in", .zoomIn)
    customProperty("--cursor-zoom-out", .zoomOut)
    customProperty("--mix-blend-mode-base", .normal)

    // MARK: Background Colors
    customProperty("--background-color-base", fill)
    customProperty("--background-color-base-fixed", .white)
    customProperty("--background-color-neutral", fillTertiary)
    customProperty("--background-color-neutral-subtle", fillSecondary)
    customProperty("--background-color-interactive", fillTertiary)
    customProperty("--background-color-interactive-hover", fillGrayTertiary)
    customProperty("--background-color-interactive-active", fillGraySecondary)
    customProperty("--background-color-interactive-subtle", fillSecondary)
    customProperty("--background-color-interactive-subtle-hover", fillTertiary)
    customProperty("--background-color-interactive-subtle-active", fillGrayTertiary)
    customProperty("--background-color-disabled", fillGrayTertiary)
    customProperty("--background-color-disabled-subtle", fillTertiary)
    customProperty("--background-color-inverted", glyph)
    customProperty("--background-color-content-added", fillColor(c: 0.1944, h: hueGreen, isSubtle: true))
    customProperty("--background-color-content-removed", fillColor(c: 0.2328, h: hueRed, isSubtle: true))
    customProperty("--background-color-transparent", .transparent)
    customProperty("--background-color-backdrop-light", backdropLight)
    customProperty("--background-color-backdrop-dark", backdropDark)
    customProperty("--background-color-button-quiet-hover", rgba(0, 24, 73, 0.027))
    customProperty("--background-color-button-quiet-active", rgba(0, 24, 73, 0.082))
    customProperty("--background-color-input-binary-checked", fillBlue)
    customProperty("--background-color-tab-list-item-framed-hover", rgba(255, 255, 255, 0.3))
    customProperty("--background-color-tab-list-item-framed-active", rgba(255, 255, 255, 0.65))
    customProperty("--opacity-icon-base", 0.87)
    customProperty("--opacity-icon-base-hover", 0.74)
    customProperty("--opacity-icon-base-selected", 1)
    customProperty("--opacity-icon-base-disabled", 0.51)
    customProperty("--opacity-icon-placeholder", 0.51)
    customProperty("--opacity-icon-subtle", 0.67)
    customProperty("--min-size-interactive-pointer", px(32))
    customProperty("--min-size-interactive-touch", px(44))
    customProperty("--min-size-search-figure", px(40))
    customProperty("--min-size-icon-x-small", px(10))
    customProperty("--min-size-icon-small", px(14))
    customProperty("--min-size-icon-medium", px(18))
    customProperty("--min-size-input-binary", px(20))
    customProperty("--min-size-input-chip-clear-button", px(20))
    customProperty("--min-size-toggle-switch-grip", px(18))
    customProperty("--min-width-medium", px(256))
    customProperty("--min-width-breakpoint-mobile", px(480))
    customProperty("--min-width-breakpoint-tablet", px(769))
    customProperty("--min-width-breakpoint-desktop", px(1025))
    customProperty("--min-width-breakpoint-desktop-wide", px(1280))
    customProperty("--min-width-toggle-switch", px(42))
    customProperty("--spacing-0", 0)
    customProperty("--spacing-1", px(1))
    customProperty("--spacing-2", px(2))
    customProperty("--spacing-4", px(4))
    customProperty("--spacing-5", px(5))
    customProperty("--spacing-6", px(6))
    customProperty("--spacing-8", px(8))
    customProperty("--spacing-10", px(10))
    customProperty("--spacing-12", px(12))
    customProperty("--spacing-16", px(16))
    customProperty("--spacing-20", px(20))
    customProperty("--spacing-24", px(24))
    customProperty("--spacing-32", px(32))
    customProperty("--spacing-40", px(40))
    customProperty("--spacing-48", px(48))
    customProperty("--spacing-64", px(64))
    customProperty("--spacing-half", perc(50))
    customProperty("--spacing-full", perc(100))
    customProperty("--border-width-base", px(1))
    customProperty("--border-width-thick", px(2))
    customProperty("--border-width-input-radio-checked", px(6))
    // MARK: Border Colors
    customProperty("--border-color-base", borderNeutral)
    customProperty("--border-color-emphasized", borderEmphasis)
    customProperty("--border-color-subtle", borderNeutral)
    customProperty("--border-color-muted", borderNeutral)
    customProperty("--border-color-interactive", glyphGrayTertiary)
    customProperty("--border-color-interactive-hover", borderInteractive)
    customProperty("--border-color-interactive-active", borderInteractive)
    customProperty("--border-color-disabled", borderNeutral)
    customProperty("--border-color-inverted", fill)
    customProperty("--border-color-inverted-fixed", .white)
    customProperty("--border-color-content-added", glyphGreen)
    customProperty("--border-color-content-removed", glyphRed)
    customProperty("--border-color-transparent", .transparent)
    customProperty("--border-color-divider", borderNeutral)
    customProperty("--border-radius-minimal", px(2))  // NEW
    customProperty("--border-radius-base", px(8))
    customProperty("--border-radius-sharp", 0)
    customProperty("--border-radius-pill", px(9999))
    customProperty("--border-radius-circle", perc(50))
    customProperty("--min-height-text-area", px(64))
    customProperty("--min-height-table-header", px(40))
    customProperty("--min-height-table-footer", px(40))
    customProperty("--min-height-toggle-switch", px(28))
    customProperty("--max-height-chip", rem(1.375))
    // MARK: Links
    customProperty("--color-link", glyphBlue)
    customProperty("--color-link-hover", stateColor(glyphBlue, state: .hover))
    customProperty("--color-link-active", stateColor(glyphBlue, state: .active))
    customProperty("--color-link-focus", glyphBlue)
    customProperty("--color-link-visited", glyphBrown)
    customProperty("--color-link-visited-hover", stateColor(glyphBrown, state: .hover))
    customProperty("--color-link-visited-active", stateColor(glyphBrown, state: .active))
    customProperty("--color-link-red", glyphRed)
    customProperty("--color-link-red-hover", stateColor(glyphRed, state: .hover))
    customProperty("--color-link-red-active", stateColor(glyphRed, state: .active))
    customProperty("--color-link-red-focus", glyphBlue)
    customProperty("--color-link-red-visited", stateColor(glyphRed, state: .hover))
    customProperty("--color-link-red-visited-hover", stateColor(glyphRed, state: .active))
    customProperty("--color-link-red-visited-active", stateColor(glyphRed, state: .deep))
    customProperty("--size-icon-x-small", calc(fontSizeMedium16 - px(4)))
    customProperty("--size-icon-small", fontSizeMedium16)
    customProperty("--size-icon-medium", calc(fontSizeMedium16 + px(4)))
    customProperty("--size-toggle-switch-grip", calc(fontSizeMedium16 * 1.25))
    customProperty("--box-shadow-small", (boxShadowOutsetSmall, boxShadowColorBase))
    customProperty("--box-shadow-small-top", (boxShadowOutsetSmallTop, boxShadowColorBase))
    customProperty("--box-shadow-small-bottom", (boxShadowOutsetSmallBottom, boxShadowColorBase))
    customProperty(
      "--box-shadow-medium",
      (
        (boxShadowOutsetMediumBelow, boxShadowColorAlphaBase),
        (boxShadowOutsetMediumAround, boxShadowColorAlphaBase)
      ))
    customProperty(
      "--box-shadow-large",
      (
        (boxShadowOutsetLargeBelow, boxShadowColorAlphaBase),
        (boxShadowOutsetLargeAround, boxShadowColorAlphaBase)
      ))
    customProperty("--accent-color-base", glyphBlue)
    customProperty("--position-offset-border-width-base", "-\(borderWidthBase)")
    customProperty("--spacing-horizontal-button", calc(spacing12 - borderWidthBase))
    customProperty("--spacing-horizontal-button-icon-only", calc(spacing6 - borderWidthBase))
    customProperty("--spacing-horizontal-button-small-icon-only", calc(spacing2 - borderWidthBase))
    customProperty("--spacing-horizontal-button-small", calc(spacing6 - borderWidthBase))
    customProperty("--spacing-horizontal-button-large", calc(spacing16 - borderWidthBase))
    customProperty(
      "--spacing-horizontal-input-text-two-end-icons", calc(spacing8 * 2 + sizeIconSmall))
    customProperty("--spacing-start-typeahead-search-figure", spacing12)
    customProperty("--spacing-toggle-switch-grip-start", calc(fontSizeMedium16 * 0.375))
    customProperty("--spacing-toggle-switch-grip-end", calc(fontSizeMedium16 * 1.25))
    customProperty("--border-color-input-hover", borderColorInteractive)
    customProperty("--border-color-input-binary", borderColorInteractive)
    customProperty("--border-color-input-binary-hover", stateColor(glyphBlue, state: .hover))
    customProperty("--border-color-input-binary-active", stateColor(glyphBlue, state: .active))
    customProperty("--border-color-input-binary-focus", glyphBlue)
    customProperty("--border-color-input-binary-checked", glyphBlue)
    customProperty("--border-base", (borderWidthBase, borderStyleBase, borderColorBase))
    customProperty("--border-subtle", (borderWidthBase, borderStyleBase, borderColorSubtle))
    customProperty(
      "--border-transparent", (borderWidthBase, borderStyleBase, borderColorTransparent))
    customProperty("--outline-base-focus", (borderWidthBase, .solid, .transparent))
    customProperty("--width-toggle-switch", calc(fontSizeMedium16 * 3))
    customProperty("--height-toggle-switch", calc(fontSizeMedium16 * 2))
    customProperty(
      "--spacing-start-typeahead-search-icon",
      calc(spacingStartTypeaheadSearchFigure + (minSizeSearchFigure - minSizeIconMedium) / 2))
    customProperty(
      "--spacing-typeahead-search-focus-addition",
      calc(
        (spacingStartTypeaheadSearchFigure + minSizeSearchFigure) - (minSizeIconMedium + spacing8)))

    // MARK: HIG Component Color Aliases — Uniform 19-token block per hue
    // All 12 hues use glyph{Hue} (fg) + fill{Hue} (bg) + extreme (hover/active direction)
    // Hue order: red, orange, yellow, green, mint, teal, cyan, blue, indigo, purple, pink, brown, gray

    // -- Red
    customProperty("--color-red", glyphRed)
    customProperty("--color-red-hover", stateColor(glyphRed, state: .hover))
    customProperty("--color-red-active", stateColor(glyphRed, state: .active))
    customProperty("--color-red-focus", glyphBlue)
    customProperty("--background-color-red", fillRed)
    customProperty("--background-color-red-hover", fillColor(c: 0.2328, h: hueRed, l: fillLHover))
    customProperty("--background-color-red-active", fillColor(c: 0.2328, h: hueRed, l: fillLActive))
    customProperty("--background-color-red-focus", fillRed)
    customProperty("--background-color-red-subtle", fillColor(c: 0.2328, h: hueRed, isSubtle: true))
    customProperty("--background-color-red-subtle-hover", fillColor(c: 0.2328, h: hueRed, l: fillLHover, isSubtle: true))
    customProperty("--background-color-red-subtle-active", fillColor(c: 0.2328, h: hueRed, l: fillLActive, isSubtle: true))
    customProperty("--border-color-red", glyphRed)
    customProperty("--border-color-red-hover", stateColor(glyphRed, state: .hover))
    customProperty("--border-color-red-active", stateColor(glyphRed, state: .active))
    customProperty("--border-color-red-focus", glyphBlue)
    customProperty("--box-shadow-color-red-active", stateColor(glyphRed, state: .active))
    customProperty("--box-shadow-color-red-focus", glyphBlue)
    customProperty("--outline-color-red-focus", glyphBlue)
    customProperty("--border-red", (borderWidthBase, borderStyleBase, borderColorRed))

    // -- Orange
    customProperty("--color-orange", glyphOrange)
    customProperty("--color-orange-hover", stateColor(glyphOrange, state: .hover))
    customProperty("--color-orange-active", stateColor(glyphOrange, state: .active))
    customProperty("--color-orange-focus", glyphBlue)
    customProperty("--background-color-orange", fillOrange)
    customProperty("--background-color-orange-hover", fillColor(c: 0.1720, h: hueOrange, l: fillLHover))
    customProperty("--background-color-orange-active", fillColor(c: 0.1720, h: hueOrange, l: fillLActive))
    customProperty("--background-color-orange-focus", fillOrange)
    customProperty("--background-color-orange-subtle", fillColor(c: 0.1720, h: hueOrange, isSubtle: true))
    customProperty("--background-color-orange-subtle-hover", fillColor(c: 0.1720, h: hueOrange, l: fillLHover, isSubtle: true))
    customProperty("--background-color-orange-subtle-active", fillColor(c: 0.1720, h: hueOrange, l: fillLActive, isSubtle: true))
    customProperty("--border-color-orange", glyphOrange)
    customProperty("--border-color-orange-hover", stateColor(glyphOrange, state: .hover))
    customProperty("--border-color-orange-active", stateColor(glyphOrange, state: .active))
    customProperty("--border-color-orange-focus", glyphBlue)
    customProperty("--box-shadow-color-orange-active", stateColor(glyphOrange, state: .active))
    customProperty("--box-shadow-color-orange-focus", glyphBlue)
    customProperty("--outline-color-orange-focus", glyphBlue)
    customProperty("--border-orange", (borderWidthBase, borderStyleBase, borderColorOrange))

    // -- Yellow
    customProperty("--color-yellow", glyphYellow)
    customProperty("--color-yellow-hover", stateColor(glyphYellow, state: .hover))
    customProperty("--color-yellow-active", stateColor(glyphYellow, state: .active))
    customProperty("--color-yellow-focus", glyphBlue)
    customProperty("--background-color-yellow", fillYellow)
    customProperty("--background-color-yellow-hover", fillColor(c: 0.1768, h: hueYellow, l: fillLHover))
    customProperty("--background-color-yellow-active", fillColor(c: 0.1768, h: hueYellow, l: fillLActive))
    customProperty("--background-color-yellow-focus", fillYellow)
    customProperty("--background-color-yellow-subtle", fillColor(c: 0.1768, h: hueYellow, isSubtle: true))
    customProperty("--background-color-yellow-subtle-hover", fillColor(c: 0.1768, h: hueYellow, l: fillLHover, isSubtle: true))
    customProperty("--background-color-yellow-subtle-active", fillColor(c: 0.1768, h: hueYellow, l: fillLActive, isSubtle: true))
    customProperty("--border-color-yellow", glyphYellow)
    customProperty("--border-color-yellow-hover", stateColor(glyphYellow, state: .hover))
    customProperty("--border-color-yellow-active", stateColor(glyphYellow, state: .active))
    customProperty("--border-color-yellow-focus", glyphBlue)
    customProperty("--box-shadow-color-yellow-active", stateColor(glyphYellow, state: .active))
    customProperty("--box-shadow-color-yellow-focus", glyphBlue)
    customProperty("--outline-color-yellow-focus", glyphBlue)
    customProperty("--border-yellow", (borderWidthBase, borderStyleBase, borderColorYellow))

    // -- Green
    customProperty("--color-green", glyphGreen)
    customProperty("--color-green-hover", stateColor(glyphGreen, state: .hover))
    customProperty("--color-green-active", stateColor(glyphGreen, state: .active))
    customProperty("--color-green-focus", glyphBlue)
    customProperty("--background-color-green", fillGreen)
    customProperty("--background-color-green-hover", fillColor(c: 0.1944, h: hueGreen, l: fillLHover))
    customProperty("--background-color-green-active", fillColor(c: 0.1944, h: hueGreen, l: fillLActive))
    customProperty("--background-color-green-focus", fillGreen)
    customProperty("--background-color-green-subtle", fillColor(c: 0.1944, h: hueGreen, isSubtle: true))
    customProperty("--background-color-green-subtle-hover", fillColor(c: 0.1944, h: hueGreen, l: fillLHover, isSubtle: true))
    customProperty("--background-color-green-subtle-active", fillColor(c: 0.1944, h: hueGreen, l: fillLActive, isSubtle: true))
    customProperty("--border-color-green", glyphGreen)
    customProperty("--border-color-green-hover", stateColor(glyphGreen, state: .hover))
    customProperty("--border-color-green-active", stateColor(glyphGreen, state: .active))
    customProperty("--border-color-green-focus", glyphBlue)
    customProperty("--box-shadow-color-green-active", stateColor(glyphGreen, state: .active))
    customProperty("--box-shadow-color-green-focus", glyphBlue)
    customProperty("--outline-color-green-focus", glyphBlue)
    customProperty("--border-green", (borderWidthBase, borderStyleBase, borderColorGreen))

    // -- Mint
    customProperty("--color-mint", glyphMint)
    customProperty("--color-mint-hover", stateColor(glyphMint, state: .hover))
    customProperty("--color-mint-active", stateColor(glyphMint, state: .active))
    customProperty("--color-mint-focus", glyphBlue)
    customProperty("--background-color-mint", fillMint)
    customProperty("--background-color-mint-hover", fillColor(c: 0.1340, h: hueMint, l: fillLHover))
    customProperty("--background-color-mint-active", fillColor(c: 0.1340, h: hueMint, l: fillLActive))
    customProperty("--background-color-mint-focus", fillMint)
    customProperty("--background-color-mint-subtle", fillColor(c: 0.1340, h: hueMint, isSubtle: true))
    customProperty("--background-color-mint-subtle-hover", fillColor(c: 0.1340, h: hueMint, l: fillLHover, isSubtle: true))
    customProperty("--background-color-mint-subtle-active", fillColor(c: 0.1340, h: hueMint, l: fillLActive, isSubtle: true))
    customProperty("--border-color-mint", glyphMint)
    customProperty("--border-color-mint-hover", stateColor(glyphMint, state: .hover))
    customProperty("--border-color-mint-active", stateColor(glyphMint, state: .active))
    customProperty("--border-color-mint-focus", glyphBlue)
    customProperty("--box-shadow-color-mint-active", stateColor(glyphMint, state: .active))
    customProperty("--box-shadow-color-mint-focus", glyphBlue)
    customProperty("--outline-color-mint-focus", glyphBlue)
    customProperty("--border-mint", (borderWidthBase, borderStyleBase, borderColorMint))

    // -- Teal
    customProperty("--color-teal", glyphTeal)
    customProperty("--color-teal-hover", stateColor(glyphTeal, state: .hover))
    customProperty("--color-teal-active", stateColor(glyphTeal, state: .active))
    customProperty("--color-teal-focus", glyphBlue)
    customProperty("--background-color-teal", fillTeal)
    customProperty("--background-color-teal-hover", fillColor(c: 0.1268, h: hueTeal, l: fillLHover))
    customProperty("--background-color-teal-active", fillColor(c: 0.1268, h: hueTeal, l: fillLActive))
    customProperty("--background-color-teal-focus", fillTeal)
    customProperty("--background-color-teal-subtle", fillColor(c: 0.1268, h: hueTeal, isSubtle: true))
    customProperty("--background-color-teal-subtle-hover", fillColor(c: 0.1268, h: hueTeal, l: fillLHover, isSubtle: true))
    customProperty("--background-color-teal-subtle-active", fillColor(c: 0.1268, h: hueTeal, l: fillLActive, isSubtle: true))
    customProperty("--border-color-teal", glyphTeal)
    customProperty("--border-color-teal-hover", stateColor(glyphTeal, state: .hover))
    customProperty("--border-color-teal-active", stateColor(glyphTeal, state: .active))
    customProperty("--border-color-teal-focus", glyphBlue)
    customProperty("--box-shadow-color-teal-active", stateColor(glyphTeal, state: .active))
    customProperty("--box-shadow-color-teal-focus", glyphBlue)
    customProperty("--outline-color-teal-focus", glyphBlue)
    customProperty("--border-teal", (borderWidthBase, borderStyleBase, borderColorTeal))

    // -- Cyan
    customProperty("--color-cyan", glyphCyan)
    customProperty("--color-cyan-hover", stateColor(glyphCyan, state: .hover))
    customProperty("--color-cyan-active", stateColor(glyphCyan, state: .active))
    customProperty("--color-cyan-focus", glyphBlue)
    customProperty("--background-color-cyan", fillCyan)
    customProperty("--background-color-cyan-hover", fillColor(c: 0.1360, h: hueCyan, l: fillLHover))
    customProperty("--background-color-cyan-active", fillColor(c: 0.1360, h: hueCyan, l: fillLActive))
    customProperty("--background-color-cyan-focus", fillCyan)
    customProperty("--background-color-cyan-subtle", fillColor(c: 0.1360, h: hueCyan, isSubtle: true))
    customProperty("--background-color-cyan-subtle-hover", fillColor(c: 0.1360, h: hueCyan, l: fillLHover, isSubtle: true))
    customProperty("--background-color-cyan-subtle-active", fillColor(c: 0.1360, h: hueCyan, l: fillLActive, isSubtle: true))
    customProperty("--border-color-cyan", glyphCyan)
    customProperty("--border-color-cyan-hover", stateColor(glyphCyan, state: .hover))
    customProperty("--border-color-cyan-active", stateColor(glyphCyan, state: .active))
    customProperty("--border-color-cyan-focus", glyphBlue)
    customProperty("--box-shadow-color-cyan-active", stateColor(glyphCyan, state: .active))
    customProperty("--box-shadow-color-cyan-focus", glyphBlue)
    customProperty("--outline-color-cyan-focus", glyphBlue)
    customProperty("--border-cyan", (borderWidthBase, borderStyleBase, borderColorCyan))

    // -- Blue
    customProperty("--color-blue", glyphBlue)
    customProperty("--color-blue-hover", stateColor(glyphBlue, state: .hover))
    customProperty("--color-blue-active", stateColor(glyphBlue, state: .active))
    customProperty("--color-blue-focus", glyphBlue)
    customProperty("--background-color-blue", fillBlue)
    customProperty("--background-color-blue-hover", fillColor(c: 0.2018, h: hueBlue, l: fillLHover))
    customProperty("--background-color-blue-active", fillColor(c: 0.2018, h: hueBlue, l: fillLActive))
    customProperty("--background-color-blue-focus", fillBlue)
    customProperty("--background-color-blue-subtle", fillColor(c: 0.2018, h: hueBlue, isSubtle: true))
    customProperty("--background-color-blue-subtle-hover", fillColor(c: 0.2018, h: hueBlue, l: fillLHover, isSubtle: true))
    customProperty("--background-color-blue-subtle-active", fillColor(c: 0.2018, h: hueBlue, l: fillLActive, isSubtle: true))
    customProperty("--border-color-blue", glyphBlue)
    customProperty("--border-color-blue-hover", stateColor(glyphBlue, state: .hover))
    customProperty("--border-color-blue-active", stateColor(glyphBlue, state: .active))
    customProperty("--border-color-blue-focus", glyphBlue)
    customProperty("--box-shadow-color-blue-active", stateColor(glyphBlue, state: .active))
    customProperty("--box-shadow-color-blue-focus", glyphBlue)
    customProperty("--outline-color-blue-focus", glyphBlue)
    customProperty("--border-blue", (borderWidthBase, borderStyleBase, borderColorBlue))

    // -- Indigo (includes selected box-shadow variants)
    customProperty("--color-indigo", glyphIndigo)
    customProperty("--color-indigo-hover", stateColor(glyphIndigo, state: .hover))
    customProperty("--color-indigo-active", stateColor(glyphIndigo, state: .active))
    customProperty("--color-indigo-focus", glyphIndigo)
    customProperty("--background-color-indigo", fillIndigo)
    customProperty("--background-color-indigo-hover", fillColor(c: 0.2296, h: hueIndigo, l: fillLHover))
    customProperty("--background-color-indigo-active", fillColor(c: 0.2296, h: hueIndigo, l: fillLActive))
    customProperty("--background-color-indigo-focus", fillIndigo)
    customProperty("--background-color-indigo-subtle", fillColor(c: 0.2296, h: hueIndigo, isSubtle: true))
    customProperty("--background-color-indigo-subtle-hover", fillColor(c: 0.2296, h: hueIndigo, l: fillLHover, isSubtle: true))
    customProperty("--background-color-indigo-subtle-active", fillColor(c: 0.2296, h: hueIndigo, l: fillLActive, isSubtle: true))
    customProperty("--border-color-indigo", glyphIndigo)
    customProperty("--border-color-indigo-hover", stateColor(glyphIndigo, state: .hover))
    customProperty("--border-color-indigo-active", stateColor(glyphIndigo, state: .active))
    customProperty("--border-color-indigo-focus", glyphIndigo)
    customProperty("--box-shadow-color-indigo-active", stateColor(glyphIndigo, state: .active))
    customProperty("--box-shadow-color-indigo-focus", glyphIndigo)
    customProperty("--box-shadow-color-indigo-selected", glyphIndigo)
    customProperty("--box-shadow-color-indigo-selected-hover", stateColor(glyphIndigo, state: .hover))
    customProperty("--box-shadow-color-indigo-selected-active", stateColor(glyphIndigo, state: .active))
    customProperty("--outline-color-indigo-focus", glyphIndigo)
    customProperty("--border-indigo", (borderWidthBase, borderStyleBase, borderColorIndigo))

    // -- Purple
    customProperty("--color-purple", glyphPurple)
    customProperty("--color-purple-hover", stateColor(glyphPurple, state: .hover))
    customProperty("--color-purple-active", stateColor(glyphPurple, state: .active))
    customProperty("--color-purple-focus", glyphBlue)
    customProperty("--background-color-purple", fillPurple)
    customProperty("--background-color-purple-hover", fillColor(c: 0.2629, h: huePurple, l: fillLHover))
    customProperty("--background-color-purple-active", fillColor(c: 0.2629, h: huePurple, l: fillLActive))
    customProperty("--background-color-purple-focus", fillPurple)
    customProperty("--background-color-purple-subtle", fillColor(c: 0.2629, h: huePurple, isSubtle: true))
    customProperty("--background-color-purple-subtle-hover", fillColor(c: 0.2629, h: huePurple, l: fillLHover, isSubtle: true))
    customProperty("--background-color-purple-subtle-active", fillColor(c: 0.2629, h: huePurple, l: fillLActive, isSubtle: true))
    customProperty("--border-color-purple", glyphPurple)
    customProperty("--border-color-purple-hover", stateColor(glyphPurple, state: .hover))
    customProperty("--border-color-purple-active", stateColor(glyphPurple, state: .active))
    customProperty("--border-color-purple-focus", glyphBlue)
    customProperty("--box-shadow-color-purple-active", stateColor(glyphPurple, state: .active))
    customProperty("--box-shadow-color-purple-focus", glyphBlue)
    customProperty("--outline-color-purple-focus", glyphBlue)
    customProperty("--border-purple", (borderWidthBase, borderStyleBase, borderColorPurple))

    // -- Pink
    customProperty("--color-pink", glyphPink)
    customProperty("--color-pink-hover", stateColor(glyphPink, state: .hover))
    customProperty("--color-pink-active", stateColor(glyphPink, state: .active))
    customProperty("--color-pink-focus", glyphBlue)
    customProperty("--background-color-pink", fillPink)
    customProperty("--background-color-pink-hover", fillColor(c: 0.2383, h: huePink, l: fillLHover))
    customProperty("--background-color-pink-active", fillColor(c: 0.2383, h: huePink, l: fillLActive))
    customProperty("--background-color-pink-focus", fillPink)
    customProperty("--background-color-pink-subtle", fillColor(c: 0.2383, h: huePink, isSubtle: true))
    customProperty("--background-color-pink-subtle-hover", fillColor(c: 0.2383, h: huePink, l: fillLHover, isSubtle: true))
    customProperty("--background-color-pink-subtle-active", fillColor(c: 0.2383, h: huePink, l: fillLActive, isSubtle: true))
    customProperty("--border-color-pink", glyphPink)
    customProperty("--border-color-pink-hover", stateColor(glyphPink, state: .hover))
    customProperty("--border-color-pink-active", stateColor(glyphPink, state: .active))
    customProperty("--border-color-pink-focus", glyphBlue)
    customProperty("--box-shadow-color-pink-active", stateColor(glyphPink, state: .active))
    customProperty("--box-shadow-color-pink-focus", glyphBlue)
    customProperty("--outline-color-pink-focus", glyphBlue)
    customProperty("--border-pink", (borderWidthBase, borderStyleBase, borderColorPink))

    // -- Brown
    customProperty("--color-brown", glyphBrown)
    customProperty("--color-brown-hover", stateColor(glyphBrown, state: .hover))
    customProperty("--color-brown-active", stateColor(glyphBrown, state: .active))
    customProperty("--color-brown-focus", glyphBlue)
    customProperty("--background-color-brown", fillBrown)
    customProperty("--background-color-brown-hover", fillColor(c: 0.0727, h: hueBrown, l: fillLHover))
    customProperty("--background-color-brown-active", fillColor(c: 0.0727, h: hueBrown, l: fillLActive))
    customProperty("--background-color-brown-focus", fillBrown)
    customProperty("--background-color-brown-subtle", fillColor(c: 0.0727, h: hueBrown, isSubtle: true))
    customProperty("--background-color-brown-subtle-hover", fillColor(c: 0.0727, h: hueBrown, l: fillLHover, isSubtle: true))
    customProperty("--background-color-brown-subtle-active", fillColor(c: 0.0727, h: hueBrown, l: fillLActive, isSubtle: true))
    customProperty("--border-color-brown", glyphBrown)
    customProperty("--border-color-brown-hover", stateColor(glyphBrown, state: .hover))
    customProperty("--border-color-brown-active", stateColor(glyphBrown, state: .active))
    customProperty("--border-color-brown-focus", glyphBlue)
    customProperty("--box-shadow-color-brown-active", stateColor(glyphBrown, state: .active))
    customProperty("--box-shadow-color-brown-focus", glyphBlue)
    customProperty("--outline-color-brown-focus", glyphBlue)
    customProperty("--border-brown", (borderWidthBase, borderStyleBase, borderColorBrown))

    // -- Gray
    customProperty("--color-gray", grayGlyph)
    customProperty("--color-gray-hover", stateColor(grayGlyph, state: .hover))
    customProperty("--color-gray-active", stateColor(grayGlyph, state: .active))
    customProperty("--color-gray-focus", glyphBlue)
    customProperty("--background-color-gray", grayFill)
    customProperty("--background-color-gray-hover", fillColor(c: 0.015, h: hueGray, l: fillLHover))
    customProperty("--background-color-gray-active", fillColor(c: 0.015, h: hueGray, l: fillLActive))
    customProperty("--background-color-gray-focus", grayFill)
    customProperty("--background-color-gray-subtle", fillColor(c: 0.015, h: hueGray, isSubtle: true))
    customProperty("--background-color-gray-subtle-hover", fillColor(c: 0.015, h: hueGray, l: fillLHover, isSubtle: true))
    customProperty("--background-color-gray-subtle-active", fillColor(c: 0.015, h: hueGray, l: fillLActive, isSubtle: true))
    customProperty("--border-color-gray-hover", stateColor(grayGlyph, state: .hover))
    customProperty("--border-color-gray-active", stateColor(grayGlyph, state: .active))
    customProperty("--border-color-gray-focus", glyphBlue)
    customProperty("--box-shadow-color-gray-active", stateColor(grayGlyph, state: .active))
    customProperty("--box-shadow-color-gray-focus", glyphBlue)
    customProperty("--outline-color-gray-focus", glyphBlue)
    customProperty("--border-gray", (borderWidthBase, borderStyleBase, borderColorGray))
  }
#endif
