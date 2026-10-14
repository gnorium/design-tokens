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
  public func TypographyTokensCSS(config: TypographyConfig) -> [CSSOM.CSSRule] {
    customProperty("--typography-font-sans", config.fontSans)
    customProperty("--typography-font-sans-italic", config.fontSansItalic)
    customProperty("--typography-font-serif", config.fontSerif)
    customProperty("--typography-font-serif-italic", config.fontSerifItalic)
    customProperty("--typography-font-mono", config.fontMono)
  }

  @CSSBuilder
  public func ColorTokensCSS() -> [CSSOM.CSSRule] {
    // Traffic Lights (macOS style)
    customProperty("--traffic-light-red", oklch(l: 0.6776, c: 0.1655, h: 23.38))
    customProperty("--traffic-light-yellow", oklch(l: 0.8509, c: 0.152, h: 91.79))
    customProperty("--traffic-light-green", oklch(l: 0.7399, c: 0.159, h: 143.96))
  }

  // MARK: - Color Tokens - Light Mode
  @CSSBuilder
  public func ColorTokensLightModeCSS() -> [CSSOM.CSSRule] {
    colorScheme(.light).important()

    customProperty("--extreme", .black)
    customProperty("--extreme-inverted", .white)
    customProperty("--mix-blend-mode-blend", .multiply)
  }

  // MARK: - Color Tokens - Dark Mode
  @CSSBuilder
  public func ColorTokensDarkModeCSS() -> [CSSOM.CSSRule] {
    colorScheme(.dark).important()

    customProperty("--extreme", .white)
    customProperty("--extreme-inverted", .black)
    customProperty("--mix-blend-mode-blend", .screen)
  }

  // MARK: - Color Strategy Helpers
  /// Derive a glyph variant (hover/active) by shifting the lightness of a base color.
  public func glyphColor(from base: CSS.Color, lShift: CSS.Value? = nil) -> CSS.Color {
    let lValue: CSS.Value = lShift != nil ? CSS.Value(calc(CSS.Value.custom("l") + lShift!)) : .custom("l")
    return oklch(from: base, l: lValue, c: .custom("c"), h: .custom("h"))
  }

  public func glyphColor(from base: CSS.Color, lShift: Double) -> CSS.Color {
    glyphColor(from: base, lShift: CSS.Value(lShift))
  }

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

  /// A scheme's neutral ramp (`NamedColors.Neutral`): each step the
  /// achromatic gray at its contrast with the page, and `--glyph-gray-fixed`,
  /// light's base text at the scheme's contrast.
  @CSSBuilder
  public func NeutralTokensCSS(_ scheme: NamedColors.Scheme) -> [CSSOM.CSSRule] {
    customProperty("--background-color-current-line", NamedColors.css(NamedColors.oklch(
      (NamedColors.currentLineGray(scheme), NamedColors.currentLineGray(scheme), NamedColors.currentLineGray(scheme)))))
    for step in NamedColors.Neutral.allCases {
      customProperty(step.token, NamedColors.css(NamedColors.neutral(step, scheme)))
    }
    customProperty(
      "--glyph-gray-fixed",
      NamedColors.css(NamedColors.neutral(.glyphGray, scheme.isMoreContrast ? .lightMoreContrast : .light)))
  }

  /// A scheme's named colors (`NamedColors`, twelve hues 30° apart, here
  /// as the sRGB clips of their P3 colors; gray achromatic): each name's color and solid
  /// fill (`--glyph-{name}`, `--fill-{name}`; gray's `--gray-glyph`,
  /// `--gray-fill`) and its subtle fill (`--fill-{name}-subtle`,
  /// `--gray-fill-subtle`)—in the default schemes the color at 20% over
  /// the page, precomputed (`NamedColors.subtle`; no runtime color-mix), in
  /// the increased-contrast ones solved to carry base text at 7:1.
  @CSSBuilder
  public func NamedColorTokensCSS(_ scheme: NamedColors.Scheme) -> [CSSOM.CSSRule] {
    for name in NamedColors.names {
      // As oklch(), so transitions interpolate in Oklab (`NamedColors.css`).
      let color = NamedColors.css(name, scheme)
      let prefix = name == "gray" ? "--gray" : "--glyph-\(name)"
      let fillName = name == "gray" ? "--gray-fill" : "--fill-\(name)"
      customProperty(prefix == "--gray" ? "--gray-glyph" : prefix, color)
      customProperty(fillName, color)
      customProperty(
        "\(fillName)-subtle",
        scheme.isMoreContrast
          ? NamedColors.css(NamedColors.moreContrastSubtle(name, scheme))
          // The color at 20% over the page, precomputed in P3; here its clip.
          : NamedColors.css(NamedColors.oklch(NamedColors.rgb(NamedColors.subtle(name, scheme)))))
    }
  }

  /// A scheme's named colors in Display P3 (user, 2026-10-14), for
  /// `@media (color-gamut: p3)` after `NamedColorTokensCSS`, whose values
  /// are their sRGB clips: each hue's color and solid fill as its P3 value
  /// (`NamedColors.cssP3`), and in the default schemes its subtle fill's
  /// (`NamedColors.subtle`). Gray and the increased-contrast subtle fills (surfaces solved
  /// for base text at 7:1) keep their sRGB values.
  @CSSBuilder
  public func NamedColorTokensP3CSS(_ scheme: NamedColors.Scheme) -> [CSSOM.CSSRule] {
    for name in NamedColors.hueNames {
      let color = NamedColors.cssP3(name, scheme)!
      customProperty("--glyph-\(name)", color)
      customProperty("--fill-\(name)", color)
      if !scheme.isMoreContrast {
        customProperty("--fill-\(name)-subtle", NamedColors.cssP3(NamedColors.subtle(name, scheme)))
      }
    }
  }

  /// Code's colors by role (user, 2026-10-12), the same in every scheme:
  /// each a named color's token, so it follows the scheme and its increased
  /// contrast. Seven hues, never a state color (red, green, blue, yellow,
  /// orange), by Xcode's roles: keywords magenta (an XML element's name),
  /// attributes cyan, strings lime (an attribute's value), characters pink
  /// (a reference), type names and numbers indigo (a namespace prefix, a
  /// JSON number), preprocessor statements violet (`<?xml?>`,
  /// `<!DOCTYPE>`), constants mint (CDATA); comments the subtle gray; text
  /// and a tag's marks the text's own. Diffs and links keep their meaning:
  /// additions green, deletions red, URLs blue.
  @CSSBuilder
  public func SyntaxTokensCSS() -> [CSSOM.CSSRule] {
    let roles: [(String, String)] = [
      ("plain-text", "var(--glyph)"), ("marks", "var(--glyph)"), ("param-internal-name", "var(--glyph)"),
      ("keywords", "var(--glyph-magenta)"), ("heading", "var(--glyph-magenta)"),
      ("attributes", "var(--glyph-cyan)"), ("other-function-and-method-names", "var(--glyph-cyan)"),
      ("project-function-and-method-names", "var(--glyph-cyan)"),
      ("other-instance-variables-and-globals", "var(--glyph-cyan)"),
      ("project-instance-variables-and-globals", "var(--glyph-cyan)"),
      ("strings", "var(--glyph-lime)"),
      ("characters", "var(--glyph-pink)"),
      ("numbers", "var(--glyph-indigo)"), ("other-type-names", "var(--glyph-indigo)"),
      ("project-type-names", "var(--glyph-indigo)"),
      ("other-class-names", "var(--glyph-indigo)"), ("project-class-names", "var(--glyph-indigo)"),
      ("type-declarations", "var(--glyph-indigo)"),
      ("preprocessor-statements", "var(--glyph-violet)"), ("other-preprocessor-macros", "var(--glyph-violet)"),
      ("project-preprocessor-macros", "var(--glyph-violet)"), ("other-declarations", "var(--glyph-violet)"),
      ("other-constants", "var(--glyph-mint)"), ("project-constants", "var(--glyph-mint)"),
      ("comments", "var(--color-subtle)"), ("documentation-markup", "var(--color-subtle)"),
      ("documentation-markup-keywords", "var(--color-subtle)"),
      ("addition", "var(--glyph-green)"), ("deletion", "var(--glyph-red)"), ("urls", "var(--glyph-blue)"),
      ("highlighted", "color-mix(in srgb, var(--glyph-blue) calc(var(--opacity-low) * 100%), transparent)"),
    ]
    for (role, value) in roles {
      customProperty("--color-syntax-\(role)", value)
    }
  }

  @CSSBuilder
  public func SourceTokensLightModeLessContrastCSS() -> [CSSOM.CSSRule] {
    // Fill (surface hierarchy)
    customProperty("--fill", .white)

    // Glyph (text hierarchy)
    customProperty("--glyph", .black)
    customProperty("--glyph-fixed", .black)

    // Semantic bridge for unified applied function
    customProperty("--border-muted", oklch(0.95, 0.002, 260))
    customProperty("--border-emphasis", oklch(0.20, 0.003, 260))
    customProperty("--border-interactive", oklch(0.20, 0.003, 260))
    customProperty("--shadow-alpha", rgba(0, 0, 0, 0.06))
    customProperty("--backdrop-light", rgba(255, 255, 255, 0.65))
    customProperty("--backdrop-dark", rgba(0, 0, 0, 0.65))

    customProperty("--glyph-l-hover-offset", -0.1)
    customProperty("--glyph-l-active-offset", -0.2)

    // The neutral ramp (`NamedColors.Neutral`, user 2026-10-12).
    NeutralTokensCSS(.light)

    // The named colors (`NamedColors`, user 2026-10-11): twelve Display
    // P3 hues 30° apart from red's, and gray.
    NamedColorTokensCSS(.light)

    // Syntax colors: the named colors by role (`SyntaxTokensCSS`).
    SyntaxTokensCSS()
  }

  @CSSBuilder
  public func SourceTokensLightModeMoreContrastCSS() -> [CSSOM.CSSRule] {
    // Fill (surface hierarchy—increased contrast)
    customProperty("--fill", .white)

    // Glyph (text hierarchy—increased contrast)
    customProperty("--glyph", .black)
    customProperty("--glyph-fixed", .black)

    // Semantic bridge for unified applied function
    customProperty("--border-muted", oklch(0.92, 0.003, 260))
    customProperty("--border-emphasis", oklch(0.12, 0.004, 260))
    customProperty("--border-interactive", oklch(0.12, 0.004, 260))
    customProperty("--shadow-alpha", rgba(0, 0, 0, 0.08))
    customProperty("--backdrop-light", rgba(255, 255, 255, 0.65))
    customProperty("--backdrop-dark", rgba(0, 0, 0, 0.65))

    // The neutral ramp (`NamedColors.Neutral`, user 2026-10-12).
    NeutralTokensCSS(.lightMoreContrast)

    // The named colors (`NamedColors`, user 2026-10-11): twelve Display
    // P3 hues 30° apart from red's, and gray.
    NamedColorTokensCSS(.lightMoreContrast)
  }

  @CSSBuilder
  public func SourceTokensDarkModeLessContrastCSS() -> [CSSOM.CSSRule] {
    // Fill (surface hierarchy)
    customProperty("--fill", .black)

    // Glyph (text hierarchy)
    customProperty("--glyph", .white)
    customProperty("--glyph-fixed", .black)

    // Background Layers
    customProperty("--background-primary", oklch(0.17, 0.003, 260))
    customProperty("--background-layer1", oklch(0.27, 0.004, 260))
    customProperty("--background-layer2", oklch(0.34, 0.005, 260))
    customProperty("--backdrop", rgba(10, 10, 10, 0.8))
    customProperty("--sidebar", oklch(0.20, 0.003, 260))
    customProperty("--separator", oklch(0.28, 0.004, 260))

    // Semantic bridge for unified applied function
    customProperty("--border-muted", oklch(0.17, 0.003, 260))
    customProperty("--border-emphasis", oklch(0.96, 0.003, 260))
    customProperty("--border-interactive", oklch(0.62, 0.005, 260))
    customProperty("--shadow-alpha", rgba(0, 0, 0, 0.87))
    customProperty("--backdrop-light", rgba(0, 0, 0, 0.65))
    customProperty("--backdrop-dark", rgba(255, 255, 255, 0.65))

    customProperty("--glyph-l-hover-offset", 0.025)
    customProperty("--glyph-l-active-offset", 0.05)

    // The neutral ramp (`NamedColors.Neutral`, user 2026-10-12).
    NeutralTokensCSS(.dark)

    // The named colors (`NamedColors`, user 2026-10-11): twelve Display
    // P3 hues 30° apart from red's, and gray.
    NamedColorTokensCSS(.dark)

    // Syntax colors: the named colors by role (`SyntaxTokensCSS`).
    SyntaxTokensCSS()
  }

  @CSSBuilder
  public func SourceTokensDarkModeMoreContrastCSS() -> [CSSOM.CSSRule] {
    // Fill (surface hierarchy—increased contrast)
    customProperty("--fill", .black)

    // Glyph (text hierarchy—increased contrast)
    customProperty("--glyph", .white)
    customProperty("--glyph-fixed", .black)

    // Background Layers
    customProperty("--background-primary", oklch(0.17, 0.003, 260))
    customProperty("--background-layer1", oklch(0.27, 0.004, 260))
    customProperty("--background-layer2", oklch(0.34, 0.005, 260))
    customProperty("--backdrop", rgba(10, 10, 10, 0.85))
    customProperty("--sidebar", oklch(0.20, 0.003, 260))
    customProperty("--separator", oklch(0.28, 0.004, 260))

    // Semantic bridge for unified applied function
    customProperty("--border-muted", oklch(0.20, 0.004, 260))
    customProperty("--border-emphasis", oklch(0.98, 0.002, 260))
    customProperty("--border-interactive", oklch(0.70, 0.005, 260))
    customProperty("--shadow-alpha", rgba(0, 0, 0, 0.90))
    customProperty("--backdrop-light", rgba(0, 0, 0, 0.65))
    customProperty("--backdrop-dark", rgba(255, 255, 255, 0.65))

    // The neutral ramp (`NamedColors.Neutral`, user 2026-10-12).
    NeutralTokensCSS(.darkMoreContrast)

    // The named colors (`NamedColors`, user 2026-10-11): twelve Display
    // P3 hues 30° apart from red's, and gray.
    NamedColorTokensCSS(.darkMoreContrast)
  }

  // MARK: - Unified Applied Tokens
  // Single function for all modes. Source tokens + semantic bridge handle light/dark/contrast differences.
  // Hover/active direction: `extreme` (black in light, white in dark).
  // Inverted: `extremeInverted` (white in light, black in dark).
  // Neutral borders/disabled: `border`. Emphasized: `borderEmphasis`.
  // Interactive hover/active: `borderInteractive`. Shadows: `shadowAlpha`.
  // Backdrops: `backdropLight`/`backdropDark`.
  @CSSBuilder
  public func AppliedTokensCSS() -> [CSSOM.CSSRule] {
    // MARK: Text / Foreground
    customProperty("--color-base", glyphGray)
    customProperty("--color-base-fixed", glyphGrayFixed)
    customProperty("--color-base-hover", glyphGraySecondary)
    customProperty("--color-base-active", glyphGrayQuaternary)
    customProperty("--color-emphasized", glyph)
    customProperty("--color-subtle", glyphGraySecondary)
    customProperty("--color-disabled", glyphGrayQuaternary)
    customProperty("--color-disabled-emphasized", glyphGraySecondary)
    customProperty("--color-placeholder", glyphGrayTertiary)
    customProperty("--color-inverted", fill)
    customProperty("--color-inverted-fixed", .white)
    // A solid fill's label (user, 2026-10-12): white in light, black in dark,
    // as the named colors stand against the page first.
    customProperty("--color-on-solid", extremeInverted)
    customProperty("--color-content-added", glyphGreen)
    customProperty("--color-content-removed", glyphRed)
    customProperty("--opacity-base", 1)
    customProperty("--opacity-medium", 0.65)
    customProperty("--opacity-low", 0.2)
    customProperty("--opacity-transparent", 0)
    customProperty("--filter-invert-icon", 0)
    customProperty("--filter-invert-primary-button-icon", 1)
    customProperty("--background-position-base", CSS.BackgroundPosition.center)
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
    customProperty("--size-10", rem(0.625))
    customProperty("--size-12", rem(0.75))
    customProperty("--size-14", rem(0.875))
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
    customProperty("--max-width-base", CSS.Keyword.None.none)
    customProperty("--max-width-breakpoint-phone-narrow", px(479))  // NEW
    customProperty("--max-width-breakpoint-mobile", px(768))
    customProperty("--max-width-breakpoint-tablet", px(1024))
    customProperty("--max-width-breakpoint-desktop", px(1279))
    customProperty("--max-width-button", rem(28))
    customProperty("--border-style-base", CSS.Border.LineStyle.solid)
    customProperty("--border-style-dashed", CSS.Border.LineStyle.dashed)
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
    customProperty("--box-shadow-color-base", border)
    customProperty("--box-shadow-color-inverted", extremeInverted)
    customProperty("--box-shadow-color-alpha-base", shadowAlpha)
    customProperty("--box-shadow-color-transparent", .transparent)
    customProperty("--font-family-base", CSS.FontFamily.GenericFamily.GenericComplete.sansSerif)
    customProperty(
      "--font-family-system-sans",
      (
        "\"-apple-system\"", "\"BlinkMacSystemFont\"", "\"Segoe UI\"", "\"Roboto\"", "\"Inter\"",
        "\"Helvetica\"", "\"Arial\"", CSS.FontFamily.GenericFamily.GenericComplete.sansSerif
      ))
    customProperty(
      "--font-family-sans--fallback", CSS.FontFamily.GenericFamily.GenericComplete.sansSerif)
    // Emoji in color wherever they sit: a text stack that carries symbol
    // fonts (Noto Sans Symbols 2 has a black-and-white 👍) would otherwise
    // draw them as outlines.
    customProperty(
      "--font-family-emoji",
      (
        "\"Apple Color Emoji\"", "\"Segoe UI Emoji\"", "\"Noto Color Emoji\"",
        CSS.FontFamily.GenericFamily.GenericComplete.sansSerif
      ))
    customProperty(
      "--font-family-serif",
      (
        "\"Linux Libertine\"", "\"Georgia\"", "\"Times\"", "\"Source Serif 4\"",
        CSS.FontFamily.GenericFamily.GenericComplete.serif
      ))
    customProperty(
      "--font-family-serif--fallback", CSS.FontFamily.GenericFamily.GenericComplete.serif)
    customProperty(
      "--font-family-monospace",
      (
        "\"Menlo\"", "\"Consolas\"", "\"Liberation Mono\"", "\"Fira Code\"", "\"Courier New\"",
        CSS.FontFamily.GenericFamily.GenericComplete.monospace
      ))
    customProperty(
      "--font-family-monospace--fallback", CSS.FontFamily.GenericFamily.GenericComplete.monospace)
    customProperty(
      "--font-family-heading-main",
      (
        "\"Linux Libertine\"", "\"Georgia\"", "\"Times\"", "\"Source Serif 4\"",
        CSS.FontFamily.GenericFamily.GenericComplete.monospace
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
    customProperty("--text-decoration-none", CSS.Keyword.None.none)
    customProperty("--text-decoration-line-through", .lineThrough)
    customProperty("--text-decoration-underline", .underline)
    customProperty("--text-overflow-clip", .clip)
    customProperty("--text-overflow-ellipsis", .ellipsis)
    customProperty("--tab-size-base", 4)
    customProperty("--transform-checkbox-tick-checked", rotate(deg(45)))
    customProperty("--transform-rotating-sector-start", rotate(deg(-45)))
    customProperty("--transform-rotating-sector-end", rotate(deg(315)))
    customProperty("--transition-duration-base", ms(100))
    customProperty("--transition-duration-medium", ms(250))
    customProperty(
      "--transition-property-base", (.backgroundColor, .color, .borderColor, .boxShadow))
    customProperty("--transition-property-fade", .opacity)
    customProperty("--transition-property-icon", CSS.SingleTransitionProperty.color)
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
    customProperty("--background-color-base-hover", fillSecondary)
    customProperty("--background-color-base-active", fillTertiary)
    customProperty("--background-color-neutral", fillTertiary)
    // Fill 1, the first step from the page (user, 2026-10-12).
    customProperty("--background-color-neutral-subtle", fillSecondary)
    // A table's stripe and a row's states over it (user, 2026-10-12): the
    // subtle fills 1, 2 and 3, each above the last (`NamedColors.Neutral`).
    customProperty("--background-color-stripe", fillSecondary)
    customProperty("--background-color-stripe-hover", fillTertiary)
    customProperty("--background-color-stripe-active", fillGrayQuaternary)
    customProperty("--background-color-interactive", fillTertiary)
    customProperty("--background-color-interactive-hover", fillGrayQuaternary)
    customProperty("--background-color-interactive-active", fillGrayTertiary)
    customProperty("--background-color-interactive-subtle", fillSecondary)
    customProperty("--background-color-interactive-subtle-hover", fillTertiary)
    customProperty("--background-color-interactive-subtle-active", fillGrayQuaternary)
    customProperty("--background-color-disabled", fillGrayQuaternary)
    customProperty("--background-color-disabled-subtle", fillTertiary)
    customProperty("--background-color-inverted", glyph)
    customProperty("--background-color-content-added", backgroundColorGreenSubtle)
    customProperty("--background-color-content-removed", backgroundColorRedSubtle)
    customProperty("--background-color-transparent", .transparent)
    customProperty("--background-color-backdrop-light", backdropLight)
    customProperty("--background-color-backdrop-dark", backdropDark)
    // The light theme's dark backdrop in every theme: a scrim that darkens
    // whatever the theme (an image editor's dim outside a selection).
    customProperty("--background-color-backdrop-dark-fixed", rgba(0, 0, 0, 0.65))
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
    customProperty("--min-size-interactive-touch", px(40))
    customProperty("--min-size-search-figure", px(40))
    customProperty("--min-size-icon-x-small", px(10))
    customProperty("--min-size-icon-small", px(14))
    customProperty("--min-size-icon-medium", px(18))
    customProperty("--min-size-input-binary", px(20))
    customProperty("--min-size-input-chip-clear-button", px(20))
    customProperty("--min-size-toggle-switch-grip", px(18))
    customProperty("--min-width-medium", px(256))
    customProperty("--min-width-tree-node", rem(14))
    customProperty("--min-width-breakpoint-mobile", px(480))
    customProperty("--min-width-breakpoint-tablet", px(769))
    customProperty("--min-width-breakpoint-desktop", px(1025))
    customProperty("--min-width-breakpoint-desktop-wide", px(1280))
    customProperty("--min-width-toggle-switch", px(42))
    customProperty("--spacing-0", px(0))
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
    customProperty("--border-color-base", border)
    customProperty("--border-color-base-hover", glyphColor(from: borderColorBase, lShift: glyphLHoverOffset))
    customProperty("--border-color-base-active", glyphColor(from: borderColorBase, lShift: glyphLActiveOffset))
    customProperty("--border-color-emphasized", borderEmphasis)
    customProperty("--border-color-subtle", borderSecondary)
    customProperty("--border-color-muted", borderMuted)
    customProperty("--border-color-interactive", borderInteractive)
    customProperty("--border-color-interactive-hover", glyphColor(from: borderColorInteractive, lShift: glyphLHoverOffset))
    customProperty("--border-color-interactive-active", glyphColor(from: borderColorInteractive, lShift: glyphLActiveOffset))
    customProperty("--border-color-disabled", borderSecondary)
    customProperty("--border-color-inverted", fill)
    customProperty("--border-color-inverted-fixed", .white)
    customProperty("--border-color-content-added", glyphGreen)
    customProperty("--border-color-content-removed", glyphRed)
    customProperty("--border-color-transparent", .transparent)
    customProperty("--border-color-divider", borderMuted)
    customProperty("--border-radius-minimal", px(4))  // NEW
    customProperty("--border-radius-base", px(16))
    customProperty("--border-radius-sharp", px(0))
    customProperty("--border-radius-pill", px(9999))
    customProperty("--border-radius-circle", perc(50))
    customProperty("--min-height-text-area", px(64))
    customProperty("--min-height-table-header", px(40))
    customProperty("--min-height-table-footer", px(40))
    customProperty("--min-height-toggle-switch", px(28))
    customProperty("--max-height-chip", rem(1.375))
    // MARK: Links
    customProperty("--color-link", glyphBlue)
    customProperty("--color-link-hover", glyphColor(from: glyphBlue, lShift: glyphLHoverOffset))
    customProperty("--color-link-active", glyphColor(from: glyphBlue, lShift: glyphLActiveOffset))
    customProperty("--color-link-focus", glyphBlue)
    customProperty("--color-link-visited", glyphOrange)
    customProperty("--color-link-visited-hover", glyphColor(from: glyphOrange, lShift: glyphLHoverOffset))
    customProperty("--color-link-visited-active", glyphColor(from: glyphOrange, lShift: glyphLActiveOffset))
    customProperty("--color-link-red", glyphRed)
    customProperty("--color-link-red-hover", glyphColor(from: glyphRed, lShift: glyphLHoverOffset))
    customProperty("--color-link-red-active", glyphColor(from: glyphRed, lShift: glyphLActiveOffset))
    customProperty("--color-link-red-focus", glyphBlue)
    customProperty("--color-link-red-visited", glyphPink)
    customProperty("--color-link-red-visited-hover", glyphColor(from: glyphPink, lShift: glyphLHoverOffset))
    customProperty("--color-link-red-visited-active", glyphColor(from: glyphPink, lShift: glyphLActiveOffset))
    customProperty("--size-icon-x-small", calc(fontSizeMedium16 - px(4)))
    customProperty("--size-icon-small", fontSizeMedium16)
    customProperty("--size-icon-medium", calc(fontSizeMedium16 + px(4)))
    customProperty("--size-toggle-switch-grip", calc(fontSizeMedium16 * 1.25))
    customProperty("--size-edge-fade", em(2))
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
    // Small labels are 16px: 8px from the pill's edge to the text.
    customProperty("--spacing-horizontal-button-small", calc(spacing8 - borderWidthBase))
    customProperty("--spacing-horizontal-button-large", calc(spacing16 - borderWidthBase))
    customProperty(
      "--spacing-horizontal-input-text-two-end-icons", calc(spacing8 * 2 + sizeIconSmall))
    customProperty("--spacing-start-typeahead-search-figure", spacing12)
    customProperty("--spacing-toggle-switch-grip-start", calc(fontSizeMedium16 * 0.375))
    customProperty("--spacing-toggle-switch-grip-end", calc(fontSizeMedium16 * 1.25))
    customProperty("--border-color-input-hover", borderColorInteractive)
    customProperty("--border-color-input-binary", borderColorBase)
    customProperty("--border-color-input-binary-hover", borderColorBaseHover)
    customProperty("--border-color-input-binary-active", borderColorBaseActive)
    customProperty("--border-color-input-binary-focus", borderColorBlue)
    customProperty("--border-color-input-binary-checked", borderColorBlue)
    customProperty("--border-color-input-binary-checked-hover", borderColorBlueHover)
    customProperty("--border-color-input-binary-checked-active", borderColorBlueActive)
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

    // MARK: Named colors—one 19-token block per name (`NamedColors`)
    // The color and its solid fill are one token; states mix toward `extreme`
    // (black in light, white in dark); the subtle fill is the scheme's.
    for name in NamedColors.names {
      let glyph = name == "gray" ? "var(--gray-glyph)" : "var(--glyph-\(name))"
      let fill = name == "gray" ? "var(--gray-fill)" : "var(--fill-\(name))"
      let subtle = name == "gray" ? "var(--gray-fill-subtle)" : "var(--fill-\(name)-subtle)"
      let mix = { (color: String, share: Int) in "color-mix(in oklab, \(color) \(share)%, var(--extreme))" }
      customProperty("--color-\(name)", glyph)
      customProperty("--color-\(name)-hover", mix(glyph, 80))
      customProperty("--color-\(name)-active", mix(glyph, 65))
      customProperty("--color-\(name)-focus", glyphBlue)
      customProperty("--background-color-\(name)", fill)
      customProperty("--background-color-\(name)-hover", mix(fill, 85))
      customProperty("--background-color-\(name)-active", mix(fill, 70))
      customProperty("--background-color-\(name)-focus", fill)
      customProperty("--background-color-\(name)-subtle", subtle)
      customProperty("--background-color-\(name)-subtle-hover", mix(subtle, 92))
      customProperty("--background-color-\(name)-subtle-active", mix(subtle, 84))
      customProperty("--border-color-\(name)", fill)
      customProperty("--border-color-\(name)-hover", mix(fill, 85))
      customProperty("--border-color-\(name)-active", mix(fill, 70))
      customProperty("--border-color-\(name)-focus", glyphBlue)
      customProperty("--box-shadow-color-\(name)-active", mix(glyph, 65))
      customProperty("--box-shadow-color-\(name)-focus", glyphBlue)
      customProperty("--outline-color-\(name)-focus", glyphBlue)
      customProperty("--border-\(name)", "\(borderWidthBase.value) solid var(--border-color-\(name))")
    }
  }
#endif
