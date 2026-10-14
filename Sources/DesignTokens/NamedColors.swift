#if SERVER || canImport(SwiftUI)
  import Foundation

  /// Gnorium's named colors (user, 2026-10-11): twelve hues 30° apart in
  /// OKLCH, starting at pure red's (#FF0000, 29.23°), and gray.
  ///
  /// By APCA (user, 2026-10-12; P3 only 2026-10-14): each color is a
  /// Display P3 color—its hue kept, the most chroma P3 allows—at the
  /// lightness where its APCA contrast with the page (by APCA's P3
  /// luminance) is one of APCA's published levels: Lc 60 by default, Lc 75
  /// in increased contrast; dark on white in light, light on black in dark
  /// (APCA's reverse polarity). Lc 60 is APCA's minimum for content text
  /// that is not body text (about 24px regular or 16px bold): short labels
  /// and captions such as links and syntax; APCA asks Lc 75 of body text,
  /// which increased contrast meets. A solid fill's label is the page's own
  /// color (`--color-on-solid`: white in light, black in dark), at Lc 65 on
  /// the fill in light and Lc 62 in dark.
  ///
  /// P3 is the definition (user, 2026-10-14). The sRGB value is not solved
  /// for its Lc: it is the P3 color's clip, channel by channel, as browsers
  /// draw it on an sRGB screen (`clipHex`)—the CSS fallback, and what can't
  /// take P3 uses—so every sRGB path shows the same color. There its
  /// contrast drifts from the level, by the user's decision: Lc 56–64 by
  /// default, Lc 72–79 in increased contrast.
  ///
  /// Each is a color, its solid fill (the same token), and its subtle fill
  /// (`subtle`): in the default schemes the color at 20% over the page
  /// (`subtleShare`), precomputed in P3 with its clip as sRGB value; in the
  /// increased-contrast ones, the hue's lightness nearest the color's at
  /// which base text reads at 7:1.
  public enum NamedColors {
    public struct OKLCH: Sendable, Equatable {
      public let l: Double
      public let c: Double
      public let h: Double
      public init(_ l: Double, _ c: Double, _ h: Double) { self.l = l; self.c = c; self.h = h }
    }

    /// The names, one word each, in hue order from red (user, 2026-10-11).
    public static let hueNames = [
      "red", "orange", "yellow", "lime", "green", "mint", "cyan", "blue", "indigo", "violet", "magenta", "pink",
    ]

    /// Pure red's OKLCH hue, where the twelve start.
    public static var redHue: Double { oklch((255, 0, 0)).h }

    /// A name's OKLCH hue: red's, and every 30° on.
    public static func hue(_ name: String) -> Double {
      (redHue + 30 * Double(hueNames.firstIndex(of: name)!)).truncatingRemainder(dividingBy: 360)
    }

    /// OKLCH of an 8-bit sRGB color.
    public static func oklch(_ rgb: (Int, Int, Int)) -> OKLCH {
      func lin(_ v: Int) -> Double {
        let x = Double(v) / 255
        return x <= 0.04045 ? x / 12.92 : pow((x + 0.055) / 1.055, 2.4)
      }
      let (r, g, b) = (lin(rgb.0), lin(rgb.1), lin(rgb.2))
      let l = cbrt(0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b)
      let m = cbrt(0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b)
      let s = cbrt(0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b)
      let L = 0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s
      let A = 1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s
      let B = 0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s
      var h = atan2(B, A) * 180 / .pi
      if h < 0 { h += 360 }
      return OKLCH(L, (A * A + B * B).squareRoot(), h)
    }

    /// Every name the tokens carry, in order.
    public static var names: [String] { hueNames + ["gray"] }

    public enum Scheme: String, CaseIterable, Sendable {
      case light, lightMoreContrast, dark, darkMoreContrast
      public var isDark: Bool { self == .dark || self == .darkMoreContrast }
      public var isMoreContrast: Bool { self == .lightMoreContrast || self == .darkMoreContrast }
      /// The page: white in light, black in dark.
      public var page: OKLCH { isDark ? OKLCH(0, 0, 0) : OKLCH(1, 0, 0) }
      /// Base text (`colorBase`, the scheme's `--glyph-gray`): the neutral
      /// ramp's.
      public var baseText: OKLCH { NamedColors.neutral(.glyphGray, self) }
    }

    /// The minimum contrast of the increased-contrast schemes (WCAG AAA).
    public static let moreContrastMinimum = 7.0

    // MARK: Color math

    public static func linearSRGB(_ c: OKLCH) -> (r: Double, g: Double, b: Double) {
      let a = c.c * cos(c.h * .pi / 180), b = c.c * sin(c.h * .pi / 180)
      let l = pow(c.l + 0.3963377774 * a + 0.2158037573 * b, 3)
      let m = pow(c.l - 0.1055613458 * a - 0.0638541728 * b, 3)
      let s = pow(c.l - 0.0894841775 * a - 1.2914855480 * b, 3)
      return (
        4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
        -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
        -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
      )
    }

    public static func inGamut(_ c: OKLCH, tolerance: Double = 1e-7) -> Bool {
      let r = linearSRGB(c)
      return [r.r, r.g, r.b].allSatisfy { $0 >= -tolerance && $0 <= 1 + tolerance }
    }

    /// The most chroma sRGB allows at a lightness and hue.
    public static func maxChroma(l: Double, h: Double) -> Double {
      guard l > 0, l < 1 else { return 0 }
      var low = 0.0, high = 0.5
      for _ in 0..<45 {
        let mid = (low + high) / 2
        if inGamut(OKLCH(l, mid, h)) { low = mid } else { high = mid }
      }
      return low
    }

    /// 8-bit sRGB, channels clamped.
    public static func rgb(_ c: OKLCH) -> (Int, Int, Int) {
      let r = linearSRGB(c)
      func e(_ v: Double) -> Int {
        let x = min(1, max(0, v))
        return Int(((x <= 0.0031308 ? 12.92 * x : 1.055 * pow(x, 1 / 2.4) - 0.055) * 255).rounded())
      }
      return (e(r.r), e(r.g), e(r.b))
    }

    public static func hex(_ c: OKLCH) -> String {
      let (r, g, b) = rgb(c)
      return String(format: "#%02X%02X%02X", r, g, b)
    }

    /// WCAG 2 relative luminance of a color as written (8-bit sRGB).
    public static func luminance(_ c: OKLCH) -> Double {
      let (r, g, b) = rgb(c)
      func lin(_ v: Int) -> Double {
        let x = Double(v) / 255
        return x <= 0.04045 ? x / 12.92 : pow((x + 0.055) / 1.055, 2.4)
      }
      return 0.2126 * lin(r) + 0.7152 * lin(g) + 0.0722 * lin(b)
    }

    public static func contrast(_ a: OKLCH, _ b: OKLCH) -> Double {
      let (x, y) = (luminance(a), luminance(b))
      return (max(x, y) + 0.05) / (min(x, y) + 0.05)
    }

    // MARK: The rule

    /// The named colors' APCA level by default (user, 2026-10-12, kept
    /// 2026-10-14): Lc 60, APCA's minimum for short labels and captions—links
    /// and syntax.
    public static let namedLc = 60.0
    /// Their level in increased contrast: Lc 75, APCA's minimum for body text.
    public static let namedLcMoreContrast = 75.0

    /// A hue's color at an APCA contrast (|SAPC|, Lc plus its 2.7 offset)
    /// with a gray page: its hue, the most chroma Display P3 allows, at the
    /// lightness where its contrast—by APCA's Display P3 luminance—is the
    /// target; found by bisection, then as written (`cssP3`).
    public static func color(_ name: String, apca target: Double, on page: Int) -> OKLCH {
      if name == "gray" { return namedGray(apca: target, on: page) }
      let h = hue(name)
      func at(_ l: Double) -> OKLCH { OKLCH(l, maxChromaP3(l: l, h: h), h) }
      var low = 0.0, high = 1.0
      for _ in 0..<60 {
        let mid = (low + high) / 2
        // Lighter is less contrast on white, more on black.
        if (abs(APCA.sapcP3(at(mid), background: Double(page) / 255)) > target) != (page == 0) {
          low = mid
        } else {
          high = mid
        }
      }
      return written(at((low + high) / 2))
    }

    /// Gray, achromatic and so the same in sRGB and P3: the lightness at
    /// which its |SAPC| against the page is the target, written in 8-bit
    /// sRGB.
    static func namedGray(apca target: Double, on page: Int) -> OKLCH {
      func exact(_ l: Double) -> Double {
        let v = linearSRGB(OKLCH(l, 0, 0)).r
        let e = v <= 0.0031308 ? 12.92 * v : 1.055 * pow(v, 1 / 2.4) - 0.055
        return abs(APCA.sapc(text: (e, e, e), background: Double(page) / 255))
      }
      var low = 0.0, high = 1.0
      for _ in 0..<60 {
        let mid = (low + high) / 2
        if (exact(mid) > target) != (page == 0) { low = mid } else { high = mid }
      }
      return OKLCH((low + high) / 2, 0, 0)
    }

    /// Every name's color in every scheme, computed once.
    static let colors: [Scheme: [String: OKLCH]] = Dictionary(
      uniqueKeysWithValues: Scheme.allCases.map { scheme in
        let page = scheme.isDark ? 0 : 255
        let target = (scheme.isMoreContrast ? namedLcMoreContrast : namedLc) + APCA.loBoWoffset * 100
        return (scheme, Dictionary(uniqueKeysWithValues: names.map { ($0, color($0, apca: target, on: page)) }))
      })

    /// The color of a name in a scheme (user, 2026-10-14: P3 is the
    /// definition): at Lc 60 against the page, Lc 75 in increased contrast,
    /// in Display P3. Its sRGB value is its clip (`clipHex`), whose contrast
    /// drifts from the level: Lc 56–64 by default, Lc 72–79 in increased
    /// contrast.
    public static func color(_ name: String, _ scheme: Scheme) -> OKLCH {
      colors[scheme]![name]!
    }

    /// A name's sRGB token value (user, 2026-10-14): not solved for its Lc
    /// but defined as the sRGB clip of its P3 color (`clipHex`), written as
    /// `oklch()` of those 8 bits (`css(_:)`), so it renders exactly the clip;
    /// gray, achromatic, as its gray. The P3 value overrides it under
    /// `@media (color-gamut: p3)` (`cssP3(_:_:)`).
    public static func css(_ name: String, _ scheme: Scheme) -> String {
      css(oklch(rgb(color(name, scheme))))
    }

    /// A name's P3 token value, `oklch(L C h)` as written; nil for gray.
    public static func cssP3(_ name: String, _ scheme: Scheme) -> String? {
      name == "gray" ? nil : cssP3(color(name, scheme))
    }

    /// The sRGB clip of a name in a scheme (user, 2026-10-14), for what
    /// can't take P3—the CSS fallback, theme-color, the web manifest,
    /// emails, favicon.ico, social images: its P3 color in linear sRGB, each channel clipped to
    /// [0, 1] (relative-colorimetric clipping, as Chrome and Safari draw it
    /// on an sRGB screen), encoded to 8 bits.
    public static func clipHex(_ name: String, _ scheme: Scheme) -> String {
      hex(color(name, scheme))
    }

    /// Any in-sRGB color written as `oklch(L C h)`, so browsers interpolate
    /// in Oklab: the OKLCH of its 8-bit sRGB color, at the fewest decimals
    /// (4 to 8) at which the value stays inside sRGB and renders that same
    /// 8-bit color; on the gamut's edge, its chroma rounded down until it
    /// does. The neutral ramp and the increased-contrast subtle fills.
    public static func css(_ color: OKLCH) -> String {
      let bytes = rgb(color)
      let exact = oklch(bytes)
      for digits in 4...8 {
        let scale = pow(10, Double(digits))
        let l = (exact.l * scale).rounded() / scale
        let h = (exact.h * scale).rounded() / scale
        var c = (exact.c * scale).rounded() / scale
        for _ in 0..<20 {
          let candidate = OKLCH(l, c, h)
          if inGamut(candidate, tolerance: 1e-12), rgb(candidate) == bytes {
            return "oklch(\(format(l, digits)) \(format(c, digits)) \(format(h, digits)))"
          }
          c = max(0, c - 1 / scale)
        }
      }
      return hex(color)
    }

    static func format(_ value: Double, _ digits: Int) -> String {
      String(format: "%.\(digits)f", value)
    }

    // MARK: Display P3

    /// Linear Display P3 of an OKLCH color: OKLab to LMS to CIE XYZ (D65) to
    /// P3, by CSS Color 4's matrices.
    public static func linearDisplayP3(_ c: OKLCH) -> (r: Double, g: Double, b: Double) {
      let a = c.c * cos(c.h * .pi / 180), b = c.c * sin(c.h * .pi / 180)
      let l = pow(c.l + 0.3963377773761749 * a + 0.2158037573099136 * b, 3)
      let m = pow(c.l - 0.1055613458156586 * a - 0.0638541728258133 * b, 3)
      let s = pow(c.l - 0.0894841775298119 * a - 1.2914855480194092 * b, 3)
      let x = 1.2268798758459243 * l - 0.5578149944602171 * m + 0.2813910456659647 * s
      let y = -0.0405757452148008 * l + 1.1122868032803170 * m - 0.0717110580655164 * s
      let z = -0.0763729366746601 * l - 0.4214933324022432 * m + 1.5869240198367816 * s
      return (
        446124 / 178915 * x - 333277 / 357830 * y - 72051 / 178915 * z,
        -14852 / 17905 * x + 63121 / 35810 * y + 423 / 17905 * z,
        11844 / 330415 * x - 50337 / 660830 * y + 316169 / 330415 * z
      )
    }

    /// Gamma-encoded Display P3 channels (the sRGB curve), for an Apple
    /// `Color(.displayP3, …)`.
    public static func displayP3(_ c: OKLCH) -> (r: Double, g: Double, b: Double) {
      let p = linearDisplayP3(c)
      func encode(_ v: Double) -> Double {
        let x = min(1, max(0, v))
        return x <= 0.0031308 ? 12.92 * x : 1.055 * pow(x, 1 / 2.4) - 0.055
      }
      return (encode(p.r), encode(p.g), encode(p.b))
    }

    public static func inDisplayP3(_ c: OKLCH, tolerance: Double = 1e-7) -> Bool {
      let p = linearDisplayP3(c)
      return [p.r, p.g, p.b].allSatisfy { $0 >= -tolerance && $0 <= 1 + tolerance }
    }

    /// The most chroma Display P3 allows at a lightness and hue, by bisection.
    public static func maxChromaP3(l: Double, h: Double) -> Double {
      guard l > 0, l < 1 else { return 0 }
      var low = 0.0, high = 0.6
      for _ in 0..<50 {
        let mid = (low + high) / 2
        if inDisplayP3(OKLCH(l, mid, h)) { low = mid } else { high = mid }
      }
      return low
    }

    /// APCA's published Lc of a Display P3 color on a gray page (8-bit), by
    /// APCA's own Display P3 luminance (`displayP3toY`).
    public static func lcP3(_ c: OKLCH, on page: Int) -> Double {
      APCA.lc(sapc: APCA.sapcP3(c, background: Double(page) / 255))
    }

    /// A P3 color as written: lightness and hue to 4 decimals, chroma
    /// rounded down to 4 decimals until the value is inside Display P3.
    static func written(_ color: OKLCH) -> OKLCH {
      let l = (color.l * 1e4).rounded() / 1e4, h = (color.h * 1e4).rounded() / 1e4
      var c = (maxChromaP3(l: l, h: h) * 1e4).rounded(.down) / 1e4
      while c > 0, !inDisplayP3(OKLCH(l, c, h), tolerance: 1e-12) { c -= 1e-4 }
      return OKLCH(l, (max(0, c) * 1e4).rounded() / 1e4, h)
    }

    /// A P3 color written for CSS as `oklch(L C h)` (`written`).
    public static func cssP3(_ color: OKLCH) -> String {
      "oklch(\(format(color.l, 4)) \(format(color.c, 4)) \(format(color.h, 4)))"
    }

    // MARK: APCA

    /// APCA contrast, SAPC/APCA 0.0.98G-4g (apca-w3), computed exactly.
    public enum APCA {
      static let mainTRC = 2.4
      static let sRco = 0.2126729, sGco = 0.7151522, sBco = 0.0721750
      static let normBG = 0.56, normTXT = 0.57, revTXT = 0.62, revBG = 0.65
      static let blkThrs = 0.022, blkClmp = 1.414
      static let scaleBoW = 1.14, scaleWoB = 1.14
      static let loBoWoffset = 0.027, loWoBoffset = 0.027
      static let deltaYmin = 0.0005, loClip = 0.1

      /// APCA's screen luminance of an 8-bit sRGB color, soft-clamped near black.
      static func y(_ rgb: (Int, Int, Int)) -> Double {
        let y =
          sRco * pow(Double(rgb.0) / 255, mainTRC) + sGco * pow(Double(rgb.1) / 255, mainTRC)
          + sBco * pow(Double(rgb.2) / 255, mainTRC)
        return y > blkThrs ? y : y + pow(blkThrs - y, blkClmp)
      }

      /// SAPC ×100 of gamma-encoded sRGB channels in [0, 1] (a text) on a
      /// gray background in [0, 1]: the same as the 8-bit one, unrounded.
      static func sapc(text: (Double, Double, Double), background: Double) -> Double {
        func clamp(_ y: Double) -> Double { y > blkThrs ? y : y + pow(blkThrs - y, blkClmp) }
        let t = clamp(sRco * pow(text.0, mainTRC) + sGco * pow(text.1, mainTRC) + sBco * pow(text.2, mainTRC))
        let b = clamp(pow(background, mainTRC))
        if abs(b - t) < deltaYmin { return 0 }
        return (b > t ? (pow(b, normBG) - pow(t, normTXT)) * scaleBoW : (pow(b, revBG) - pow(t, revTXT)) * scaleWoB) * 100
      }

      /// SAPC ×100, signed (+ dark on light, − light on dark), before
      /// `loClip` and the offsets: the contrast the published Lc reads as 0
      /// below 10, kept so pale fills can be spaced and mirrored.
      public static func sapc(text: (Int, Int, Int), background: (Int, Int, Int)) -> Double {
        let t = y(text), b = y(background)
        if abs(b - t) < deltaYmin { return 0 }
        return (b > t ? (pow(b, normBG) - pow(t, normTXT)) * scaleBoW : (pow(b, revBG) - pow(t, revTXT)) * scaleWoB) * 100
      }

      /// The published Lc: clipped below 10 and offset.
      public static func lc(text: (Int, Int, Int), background: (Int, Int, Int)) -> Double {
        lc(sapc: sapc(text: text, background: background))
      }

      /// The published Lc of a SAPC ×100: clipped below 10 and offset.
      public static func lc(sapc value: Double) -> Double {
        let s = value / 100
        if s > 0 { return s < loClip ? 0 : (s - loBoWoffset) * 100 }
        if s < 0 { return s > -loClip ? 0 : (s + loWoBoffset) * 100 }
        return 0
      }

      /// Display P3's luminance coefficients in APCA (`displayP3toY`).
      static let pRco = 0.2289829594805780, pGco = 0.6917492625852380, pBco = 0.0792677779341829

      /// SAPC ×100, signed, of an OKLCH color drawn in Display P3 (encoded
      /// with the sRGB curve, as P3 is) on a gray background in [0, 1].
      public static func sapcP3(_ c: OKLCH, background: Double) -> Double {
        let p = linearDisplayP3(c)
        func encode(_ v: Double) -> Double {
          let x = min(1, max(0, v))
          return x <= 0.0031308 ? 12.92 * x : 1.055 * pow(x, 1 / 2.4) - 0.055
        }
        func clamp(_ y: Double) -> Double { y > blkThrs ? y : y + pow(blkThrs - y, blkClmp) }
        let t = clamp(
          pRco * pow(encode(p.r), mainTRC) + pGco * pow(encode(p.g), mainTRC) + pBco * pow(encode(p.b), mainTRC))
        let b = clamp(pow(background, mainTRC))
        if abs(b - t) < deltaYmin { return 0 }
        return (b > t ? (pow(b, normBG) - pow(t, normTXT)) * scaleBoW : (pow(b, revBG) - pow(t, revTXT)) * scaleWoB) * 100
      }
    }

    // MARK: The neutral ramp

    /// The neutral ramp (user, 2026-10-12): every neutral fill, border and
    /// text is an achromatic gray, set in light and mirrored to dark by
    /// equal APCA contrast with the page (`APCA.sapc`), with WCAG 2 as
    /// floors.
    ///
    /// Fills: five steps evenly spaced in APCA from the page, a step a third
    /// of the 3:1 gray's at `opacity-low` over white (fill 3); the neutral
    /// subtle fill and a table's stripe are fill 1. Foreground, in light:
    /// the base border at 3:1 (WCAG 1.4.11), disabled text at 3.96:1,
    /// placeholder at 4.5:1 on the page and on fill 3 (WCAG 1.4.3), subtle
    /// text at APCA Lc 75 (APCA's minimum for body text), base text at 18.12:1. Increased contrast raises
    /// the foreground only: the base border to the APCA of 7:1, every text
    /// step keeping its fraction of the way from the border to the APCA
    /// maximum; the fills stay.
    public enum Neutral: String, CaseIterable, Sendable {
      /// `--fill-secondary`: fill 1—the neutral subtle fill, a table's stripe,
      /// the interactive subtle fill, the base hover.
      case fillSecondary
      /// `--fill-tertiary`: fill 2—the interactive fill, the interactive
      /// subtle hover, the disabled subtle fill, the base active.
      case fillTertiary
      /// `--fill-gray-quaternary`: fill 3—a stripe's active row, the
      /// interactive hover, the interactive subtle active, the disabled fill.
      case fillGrayQuaternary
      /// `--fill-quaternary`: fill 4.
      case fillQuaternary
      /// `--fill-gray-tertiary`: fill 5—the interactive active (pressed) fill.
      case fillGrayTertiary
      /// `--border-secondary`: the subtle border—decorative and grouping
      /// lines (WCAG 2.x 1.4.11 asks 3:1 only of a boundary needed to
      /// identify a component), and the disabled border: midway in APCA
      /// between fill 5 and the base border.
      case borderSecondary
      /// `--border`: the base border.
      case border
      /// `--glyph-gray-quaternary`: disabled text.
      case glyphGrayQuaternary
      /// `--glyph-gray-tertiary`: placeholder text.
      case glyphGrayTertiary
      /// `--glyph-gray-secondary`: subtle text.
      case glyphGraySecondary
      /// `--glyph-gray`: base text.
      case glyphGray

      /// The custom property it is written as.
      public var token: String {
        var out = "--"
        for ch in rawValue {
          if ch.isUppercase { out += "-" + ch.lowercased() } else { out.append(ch) }
        }
        return out
      }

      /// Its fill step (1–5), or nil for the foreground.
      public var fillStep: Int? {
        switch self {
        case .fillSecondary: return 1
        case .fillTertiary: return 2
        case .fillGrayQuaternary: return 3
        case .fillQuaternary: return 4
        case .fillGrayTertiary: return 5
        default: return nil
        }
      }

      /// The foreground, lowest contrast first.
      public static let foreground: [Neutral] = [.border, .glyphGrayQuaternary, .glyphGrayTertiary, .glyphGraySecondary, .glyphGray]
    }

    /// A subtle fill is its color at 20% over the page (user, 2026-10-14).
    /// A build-time constant, not a runtime opacity: it precomputes the
    /// named subtle fills (`subtle`) and anchors the neutral ramp (the 3:1
    /// gray at this share over white sets the fill steps). The CSS
    /// `--opacity-low` stays only for what is genuinely translucent (the
    /// selection highlight).
    public static let subtleShare = 0.2

    static func rgb(_ v: Int) -> (Int, Int, Int) { (v, v, v) }

    /// WCAG 2 contrast of two 8-bit grays.
    public static func wcag(_ a: Int, _ b: Int) -> Double {
      contrast(oklch(rgb(a)), oklch(rgb(b)))
    }

    /// |SAPC| of a gray against a page.
    public static func apca(_ v: Int, on page: Int) -> Double {
      abs(APCA.sapc(text: rgb(v), background: rgb(page)))
    }

    /// The gray nearest a |SAPC| against a page.
    static func gray(apca target: Double, on page: Int) -> Int {
      (0...255).min { abs(apca($0, on: page) - target) < abs(apca($1, on: page) - target) }!
    }

    /// The gray nearest a WCAG 2 ratio against a background without falling
    /// below it, on the side away from the page.
    static func gray(wcag target: Double, on background: Int, darker: Bool) -> Int {
      let side = (0...255).filter { darker ? $0 < background : $0 > background }
      let meeting = side.filter { wcag($0, background) >= target }
      return meeting.min { wcag($0, background) < wcag($1, background) } ?? (darker ? 0 : 255)
    }

    /// The whole ramp in each scheme, as grays, computed once.
    static let neutralRamps: [Scheme: [Neutral: Int]] = Dictionary(
      uniqueKeysWithValues: Scheme.allCases.map { ($0, computeNeutralRamp($0)) })

    /// The whole ramp in a scheme, as grays.
    public static func neutralRamp(_ scheme: Scheme) -> [Neutral: Int] { neutralRamps[scheme]! }

    /// A faint editor band is a surface, not text. Mirror its light fill's
    /// luminance contrast on black; SAPC's near-black soft clamp overstates
    /// the dark fill at this very low contrast.
    public static func currentLineGray(_ scheme: Scheme) -> Int {
      let light = neutralRamp(.light)[.fillSecondary]!
      guard scheme.isDark else { return light }
      let target = wcag(light, 255)
      return (0...255).min { abs(wcag($0, 0) - target) < abs(wcag($1, 0) - target) }!
    }

    static func computeNeutralRamp(_ scheme: Scheme) -> [Neutral: Int] {
      let white: Int = 255, black: Int = 0
      let page: Int = scheme.isDark ? black : white
      // Fills: steps of a third of the neutral subtle fill's APCA in light.
      let gray3 = gray(wcag: 3, on: white, darker: true)
      let subtle = Int((subtleShare * Double(gray3) + (1 - subtleShare) * 255).rounded())
      let step = apca(subtle, on: white) / 3
      var ramp: [Neutral: Int] = [:]
      for n in Neutral.allCases { if let k = n.fillStep { ramp[n] = gray(apca: Double(k) * step, on: page) } }
      let lightFill3 = gray(apca: 3 * step, on: white)
      // The foreground, by one rule in every scheme, built on white and
      // mirrored to dark by equal APCA: the base border at 3:1's APCA by
      // default (WCAG 2.x 1.4.11), 7:1's in increased contrast; each text
      // step above it at the same fraction of the way from the border to
      // the APCA maximum as light's anchors set it (disabled 3.96:1,
      // placeholder 4.5:1 on the page and on fill 3, subtle text Lc 75,
      // base text 18.12:1).
      let lightTop = apca(black, on: white)
      let lightBorder = apca(gray(wcag: 3, on: white, darker: true), on: white)
      let anchors: [Neutral: Double] = [
        .glyphGrayQuaternary: apca(gray(wcag: 3.96, on: white, darker: true), on: white),
        .glyphGrayTertiary: apca(
          min(gray(wcag: 4.5, on: white, darker: true), gray(wcag: 4.5, on: lightFill3, darker: true)), on: white),
        .glyphGraySecondary: apca(
          (0...255).filter { abs(APCA.lc(text: rgb($0), background: rgb(white))) >= 75 }.max()!, on: white),
        .glyphGray: apca(gray(wcag: 18.12, on: white, darker: true), on: white),
      ]
      let border = scheme.isMoreContrast ? apca(gray(wcag: 7, on: white, darker: true), on: white) : lightBorder
      let top = lightTop
      var light: [Neutral: Double] = [.border: border]
      for (n, value) in anchors {
        light[n] = border + (value - lightBorder) / (lightTop - lightBorder) * (top - border)
      }
      // Distinct and ordered.
      var previous: Int? = nil
      for n in Neutral.foreground {
        var v = gray(apca: light[n]!, on: page)
        if let p = previous, scheme.isDark ? v <= p : v >= p { v = scheme.isDark ? min(255, p + 1) : max(0, p - 1) }
        ramp[n] = v
        previous = v
      }
      // WCAG 2 floors: the border 3:1; placeholder 4.5:1 on the page and the
      // subtle fill; disabled text below placeholder.
      let fill3 = ramp[.fillGrayQuaternary]!
      ramp[.border] = scheme.isDark
        ? max(ramp[.border]!, gray(wcag: 3, on: page, darker: false))
        : min(ramp[.border]!, gray(wcag: 3, on: page, darker: true))
      let placeholder = scheme.isDark
        ? max(ramp[.glyphGrayTertiary]!, gray(wcag: 4.5, on: page, darker: false), gray(wcag: 4.5, on: fill3, darker: false))
        : min(ramp[.glyphGrayTertiary]!, gray(wcag: 4.5, on: page, darker: true), gray(wcag: 4.5, on: fill3, darker: true))
      ramp[.glyphGrayTertiary] = placeholder
      if apca(ramp[.glyphGrayQuaternary]!, on: page) >= apca(placeholder, on: page) {
        ramp[.glyphGrayQuaternary] = scheme.isDark ? placeholder - 1 : placeholder + 1
      }
      // The subtle border: midway in APCA between fill 5 and the border.
      ramp[.borderSecondary] = gray(
        apca: (apca(ramp[.fillGrayTertiary]!, on: page) + apca(ramp[.border]!, on: page)) / 2, on: page)
      return ramp
    }

    /// A neutral step in a scheme (`neutralRamp`).
    public static func neutral(_ step: Neutral, _ scheme: Scheme) -> OKLCH {
      oklch(rgb(neutralRamp(scheme)[step]!))
    }

    /// A name's subtle fill in a default scheme (user, 2026-10-14): its color
    /// at 20% over the page (`subtleShare`), mixed in gamma-encoded Display
    /// P3 (as `color-mix(in display-p3, …)` does), precomputed; written as
    /// `oklch()` (`cssP3`), its sRGB value its clip (`css(_:)` of
    /// `rgb`). Gray's is achromatic.
    public static func subtle(_ name: String, _ scheme: Scheme) -> OKLCH {
      let c = displayP3(color(name, scheme)), page = scheme.isDark ? 0.0 : 1.0
      func mix(_ v: Double) -> Double { subtleShare * v + (1 - subtleShare) * page }
      let mixed = oklch(displayP3: (mix(c.r), mix(c.g), mix(c.b)))
      if name == "gray" { return OKLCH(mixed.l, 0, 0) }
      // As written: 4 decimals, chroma down until inside P3.
      let l = (mixed.l * 1e4).rounded() / 1e4, h = (mixed.h * 1e4).rounded() / 1e4
      var ch = (mixed.c * 1e4).rounded() / 1e4
      while ch > 0, !inDisplayP3(OKLCH(l, ch, h), tolerance: 1e-12) { ch -= 1e-4 }
      return OKLCH(l, (max(0, ch) * 1e4).rounded() / 1e4, h)
    }

    /// OKLCH of gamma-encoded Display P3 channels: decoded, P3 to CIE XYZ
    /// (D65) to LMS to OKLab, by CSS Color 4's matrices.
    public static func oklch(displayP3 e: (Double, Double, Double)) -> OKLCH {
      func lin(_ v: Double) -> Double { v <= 0.04045 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4) }
      let (r, g, b) = (lin(e.0), lin(e.1), lin(e.2))
      let x = 608311 / 1250200 * r + 189793 / 714400 * g + 198249 / 1000160 * b
      let y = 35783 / 156275 * r + 247089 / 357200 * g + 198249 / 2500400 * b
      let z = 0 * r + 32229 / 714400 * g + 5220557 / 5000800 * b
      let l = cbrt(0.8190224379967030 * x + 0.3619062600528904 * y - 0.1288737815209879 * z)
      let m = cbrt(0.0329836539323885 * x + 0.9292868615863434 * y + 0.0361446663506424 * z)
      let s = cbrt(0.0481771893596242 * x + 0.2642395317527308 * y + 0.6335478284694309 * z)
      let L = 0.2104542683093140 * l + 0.7936177747023054 * m - 0.0040720430116193 * s
      let A = 1.9779985324311684 * l - 2.4285922420485799 * m + 0.4505937096174110 * s
      let B = 0.0259040424655478 * l + 0.7827717124575296 * m - 0.8086757549230774 * s
      var h = atan2(B, A) * 180 / .pi
      if h < 0 { h += 360 }
      return OKLCH(L, (A * A + B * B).squareRoot(), h)
    }

    /// The subtle fill of the increased-contrast schemes: the color's hue,
    /// base text on it at 7:1, the lightness nearest the color's.
    public static func moreContrastSubtle(_ name: String, _ scheme: Scheme) -> OKLCH {
      let base = color(name, scheme)
      return nearest(from: base, darker: scheme.isDark) { contrast($0, scheme.baseText) >= moreContrastMinimum }
    }

    /// The lightness nearest `start`'s, moving one way only, at which
    /// `meets` holds, with the most chroma sRGB allows there (none for an
    /// achromatic start); `start` itself when it already meets.
    static func nearest(from start: OKLCH, darker: Bool, _ meets: (OKLCH) -> Bool) -> OKLCH {
      func at(_ l: Double) -> OKLCH {
        start.c == 0 ? OKLCH(l, 0, 0) : OKLCH(l, maxChroma(l: l, h: start.h), start.h)
      }
      if meets(start) { return start }
      var near = start.l, far = darker ? 0.0 : 1.0
      guard meets(at(far)) else { return at(far) }
      for _ in 0..<50 {
        let mid = (near + far) / 2
        if meets(at(mid)) { far = mid } else { near = mid }
      }
      return at(far)
    }
  }
#endif
