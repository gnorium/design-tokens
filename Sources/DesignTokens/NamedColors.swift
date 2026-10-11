#if SERVER
  import Foundation

  /// Gnorium's named colors (user, 2026-10-11): the twelve pure hues of the
  /// RGB color wheel—HSV hue in 30° steps at full saturation and value,
  /// "they are the definition"—and white, gray and black. Each sits on the sRGB
  /// gamut's edge: one channel full, one empty.
  ///
  /// The default schemes use each as it is, light and dark alike: a color,
  /// its solid fill (the same token) under a white label (white on every hue
  /// for now), and its subtle fill, the color at `opacity-low` over the page.
  /// The increased-contrast schemes keep each color's OKLCH hue and move only
  /// lightness, to the nearest at which it reads at 7:1 on the page, with the
  /// most chroma sRGB allows there; their subtle fills carry base text at 7:1.
  public enum NamedColors {
    public struct OKLCH: Sendable, Equatable {
      public let l: Double
      public let c: Double
      public let h: Double
      public init(_ l: Double, _ c: Double, _ h: Double) { self.l = l; self.c = c; self.h = h }
    }

    /// A hue name—the RGB wheel's own, kebab-cased as the tokens are—and
    /// its HSV hue, in degrees.
    public struct Hue: Sendable {
      public let name: String
      public let hsv: Double
    }

    /// All twelve wheel hues, 30° apart (user, 2026-10-11).
    public static let hues: [Hue] = [
      ("red", 0), ("orange", 30), ("yellow", 60), ("chartreuse", 90), ("green", 120), ("spring-green", 150),
      ("cyan", 180), ("azure", 210), ("blue", 240), ("violet", 270), ("magenta", 300), ("rose", 330),
    ].map { Hue(name: $0.0, hsv: $0.1) }

    /// 8-bit sRGB of an HSV hue at full saturation and value.
    public static func wheel(_ degrees: Double) -> (Int, Int, Int) {
      let h = (degrees.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360) / 60
      let x = 1 - abs(h.truncatingRemainder(dividingBy: 2) - 1)
      let (r, g, b): (Double, Double, Double)
      switch Int(h) {
      case 0: (r, g, b) = (1, x, 0)
      case 1: (r, g, b) = (x, 1, 0)
      case 2: (r, g, b) = (0, 1, x)
      case 3: (r, g, b) = (0, x, 1)
      case 4: (r, g, b) = (x, 0, 1)
      default: (r, g, b) = (1, 0, x)
      }
      // Half a step rounds up, as #FF8000 writes 0.5.
      func byte(_ v: Double) -> Int { Int((v * 255).rounded(.toNearestOrAwayFromZero)) }
      return (byte(r), byte(g), byte(b))
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

    /// Gray: middle gray, Munsell value 5.5 (ISCC–NBS 265 medium gray),
    /// achromatic.
    public static let grayValue = 5.5

    /// Every name the tokens carry, in order.
    public static var names: [String] { hues.map(\.name) + ["gray"] }

    public enum Scheme: String, CaseIterable, Sendable {
      case light, lightMoreContrast, dark, darkMoreContrast
      public var isDark: Bool { self == .dark || self == .darkMoreContrast }
      public var isMoreContrast: Bool { self == .lightMoreContrast || self == .darkMoreContrast }
      /// The page: white in light, black in dark.
      public var page: OKLCH { isDark ? OKLCH(0, 0, 0) : OKLCH(1, 0, 0) }
      /// Base text (`colorBase`, the scheme's `--glyph-gray`).
      public var baseText: OKLCH {
        switch self {
        case .light: return OKLCH(0.20, 0.003, 260)
        case .lightMoreContrast: return OKLCH(0.12, 0.004, 260)
        case .dark: return OKLCH(0.96, 0.003, 260)
        case .darkMoreContrast: return OKLCH(0.98, 0.002, 260)
        }
      }
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

    public static func inGamut(_ c: OKLCH) -> Bool {
      let r = linearSRGB(c)
      return [r.r, r.g, r.b].allSatisfy { $0 >= -1e-7 && $0 <= 1 + 1e-7 }
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

    /// Gray's lightness: Munsell value 5.5 by the ASTM D1535 value function
    /// (Y relative to the renotation's MgO reference, as its tables give it).
    public static var gray: OKLCH {
      let v = grayValue
      let y = (1.1914 * v - 0.22533 * v * v + 0.23352 * pow(v, 3) - 0.020484 * pow(v, 4) + 0.00081939 * pow(v, 5)) / 100
      return OKLCH(cbrt(y), 0, 0)
    }

    // MARK: The rule

    /// The color of a name in a scheme.
    /// A hue's color on the wheel.
    static func base(_ name: String) -> OKLCH {
      name == "gray" ? gray : oklch(wheel(hues.first { $0.name == name }!.hsv))
    }

    /// The hex a name is written as in a scheme: the wheel's own bytes in
    /// the default schemes.
    public static func hex(_ name: String, _ scheme: Scheme) -> String {
      if !scheme.isMoreContrast, let hue = hues.first(where: { $0.name == name }) {
        let (r, g, b) = wheel(hue.hsv)
        return String(format: "#%02X%02X%02X", r, g, b)
      }
      return hex(color(name, scheme))
    }

    public static func color(_ name: String, _ scheme: Scheme) -> OKLCH {
      let base = base(name)
      guard scheme.isMoreContrast else { return base }
      // Lighter or darker toward more contrast with the page.
      return nearest(from: base, darker: !scheme.isDark) { contrast($0, scheme.page) >= moreContrastMinimum }
    }

    /// The subtle fill of the increased-contrast schemes: the color's hue,
    /// base text on it at 7:1, the lightness nearest the color's.
    public static func moreContrastSubtle(_ name: String, _ scheme: Scheme) -> OKLCH {
      let base = base(name)
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
