#if SERVER || canImport(SwiftUI)
  import Foundation

  /// Gnorium's named colors (user, 2026-10-11): twelve hues 30° apart in
  /// OKLCH, starting at pure red's (#FF0000, 29.23°), and gray.
  ///
  /// Each color's lightness is set so its WCAG contrast with the page is
  /// exactly the scheme's target, with the most chroma sRGB allows at that
  /// lightness, its hue kept: 3:1 in the default schemes (light against
  /// white, dark against black), 7:1 in the increased-contrast ones. A
  /// color's contrasts with white and with black multiply to 21, so 3:1
  /// against white is 7:1 against black (relative luminance 0.3, set A) and
  /// 7:1 against white is 3:1 against black (luminance 0.1, set B): light's
  /// default and dark's increased contrast are set A; dark's default and
  /// light's increased contrast are set B.
  ///
  /// Each is a color, its solid fill (the same token) under a white label,
  /// and its subtle fill: the color at `opacity-low` over the page in the
  /// default schemes; in the increased-contrast ones, the hue's lightness
  /// nearest the color's at which base text reads at 7:1.
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

    /// Set A's relative luminance: 3:1 against white, 7:1 against black.
    public static let luminanceA = 0.3
    /// Set B's: 7:1 against white, 3:1 against black.
    public static let luminanceB = 0.1

    /// The luminance a scheme's colors stand at: set A in light and in
    /// dark's increased contrast, set B in dark and in light's.
    public static func luminance(of scheme: Scheme) -> Double {
      switch scheme {
      case .light, .darkMoreContrast: return luminanceA
      case .dark, .lightMoreContrast: return luminanceB
      }
    }

    /// A name's color at a relative luminance: its hue (gray none), the
    /// lightness at which it stands there, the most chroma sRGB allows at
    /// that lightness: found by bisection on the exact (unrounded)
    /// luminance, then written in 8-bit sRGB.
    public static func color(_ name: String, luminance target: Double) -> OKLCH {
      let gray = name == "gray"
      let h = gray ? 0 : hue(name)
      func at(_ l: Double) -> OKLCH { gray ? OKLCH(l, 0, 0) : OKLCH(l, maxChroma(l: l, h: h), h) }
      func exact(_ c: OKLCH) -> Double {
        let r = linearSRGB(c)
        let clamp = { (x: Double) in min(1, max(0, x)) }
        return 0.2126 * clamp(r.r) + 0.7152 * clamp(r.g) + 0.0722 * clamp(r.b)
      }
      var low = 0.0, high = 1.0
      for _ in 0..<60 {
        let mid = (low + high) / 2
        if exact(at(mid)) < target { low = mid } else { high = mid }
      }
      return at(high)
    }

    /// A name's color written for CSS as `oklch(L C h)` (user, 2026-10-11),
    /// so browsers interpolate its transitions in Oklab: the OKLCH of its
    /// 8-bit sRGB color, at the fewest decimals (4 to 8) at which the value
    /// stays inside sRGB—each channel in [0, 1]—and renders that same 8-bit
    /// color; on the gamut's edge, its chroma rounded down until it does.
    public static func css(_ name: String, _ scheme: Scheme) -> String {
      css(color(name, scheme))
    }

    /// Any color written so (`css(_:_:)`).
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

    /// The hex a name is written as in a scheme.
    public static func hex(_ name: String, _ scheme: Scheme) -> String {
      hex(color(name, scheme))
    }

    /// The color of a name in a scheme.
    public static func color(_ name: String, _ scheme: Scheme) -> OKLCH {
      color(name, luminance: luminance(of: scheme))
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
        let s = sapc(text: text, background: background) / 100
        if s > 0 { return s < loClip ? 0 : (s - loBoWoffset) * 100 }
        if s < 0 { return s > -loClip ? 0 : (s + loWoBoffset) * 100 }
        return 0
      }
    }

    // MARK: The neutral ramp

    /// The neutral ramp (user, 2026-10-12): every neutral fill, border and
    /// text is an achromatic gray, set in light and mirrored to dark by
    /// equal APCA contrast with the page (`APCA.sapc`), with WCAG 2 as
    /// floors.
    ///
    /// Fills: five steps evenly spaced in APCA from the page, a step a third
    /// of the neutral subtle fill's (the 3:1 gray at `opacity-low` over
    /// white), which is the third. Foreground, in light: the base border
    /// at 3:1 (WCAG 1.4.11), disabled text at 3.96:1, placeholder at 4.5:1
    /// on the page and on the subtle fill (WCAG 1.4.3), subtle text at
    /// APCA Lc 90, base text at 18.12:1. Increased contrast raises the
    /// foreground only: the base border to the APCA of 7:1, and every
    /// foreground step above it by the same map of its APCA, pinned at the
    /// page's maximum; the fills stay.
    public enum Neutral: String, CaseIterable, Sendable {
      /// `--fill-secondary`: fill 1—the interactive subtle fill, the base hover.
      case fillSecondary
      /// `--fill-tertiary`: fill 2—the interactive fill, the interactive
      /// subtle hover, the disabled subtle fill, the base active.
      case fillTertiary
      /// `--fill-gray-quaternary`: fill 3—the neutral subtle fill, the
      /// interactive hover, the interactive subtle active, the disabled fill.
      case fillGrayQuaternary
      /// `--border-secondary`: fill 4—the subtle border, the disabled border.
      case borderSecondary
      /// `--fill-gray-tertiary`: fill 5—the interactive active (pressed) fill.
      case fillGrayTertiary
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
        case .borderSecondary: return 4
        case .fillGrayTertiary: return 5
        default: return nil
        }
      }

      /// The foreground, lowest contrast first.
      public static let foreground: [Neutral] = [.border, .glyphGrayQuaternary, .glyphGrayTertiary, .glyphGraySecondary, .glyphGray]
    }

    /// `opacity-low`, at which a subtle fill lays its color over the page.
    public static let opacityLow = 0.2

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

    static func computeNeutralRamp(_ scheme: Scheme) -> [Neutral: Int] {
      let white: Int = 255, black: Int = 0
      let page: Int = scheme.isDark ? black : white
      // Fills: steps of a third of the neutral subtle fill's APCA in light.
      let gray3 = rgb(color("gray", .light)).0
      let subtle = Int((opacityLow * Double(gray3) + (1 - opacityLow) * 255).rounded())
      let step = apca(subtle, on: white) / 3
      var ramp: [Neutral: Int] = [:]
      for n in Neutral.allCases { if let k = n.fillStep { ramp[n] = gray(apca: Double(k) * step, on: page) } }
      let lightFill3 = gray(apca: 3 * step, on: white)
      // The foreground in light, as APCA.
      var light: [Neutral: Double] = [
        .border: apca(gray(wcag: 3, on: white, darker: true), on: white),
        .glyphGrayQuaternary: apca(gray(wcag: 3.96, on: white, darker: true), on: white),
        .glyphGrayTertiary: apca(
          min(gray(wcag: 4.5, on: white, darker: true), gray(wcag: 4.5, on: lightFill3, darker: true)), on: white),
        .glyphGraySecondary: apca(
          (0...255).filter { abs(APCA.lc(text: rgb($0), background: rgb(white))) >= 90 }.max()!, on: white),
        .glyphGray: apca(gray(wcag: 18.12, on: white, darker: true), on: white),
      ]
      if scheme.isMoreContrast {
        // The border to 7:1's APCA; the rest by the same map, pinned at the
        // page's maximum.
        let top = apca(scheme.isDark ? white : black, on: page)
        let target = apca(gray(wcag: 7, on: white, darker: true), on: white)
        let from = light[.border]!
        for (n, value) in light { light[n] = target + (value - from) * (top - target) / (top - from) }
      }
      // Mirrored to the scheme's page, distinct and ordered.
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
      return ramp
    }

    /// A neutral step in a scheme (`neutralRamp`).
    public static func neutral(_ step: Neutral, _ scheme: Scheme) -> OKLCH {
      oklch(rgb(neutralRamp(scheme)[step]!))
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
