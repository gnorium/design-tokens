#if SERVER || canImport(SwiftUI)
  import Foundation

  /// Gnorium's named colors (user, 2026-10-11): twelve hues 30° apart in
  /// OKLCH, starting at pure red's (#FF0000, 29.23°), each at the sRGB gamut
  /// cusp—the most chromatic color sRGB reaches at that hue—and white, gray
  /// and black.
  ///
  /// Light uses each cusp as it is; dark mirrors it—the same hue at the
  /// lightness that contrasts with black as the cusp does with white. Each
  /// is a color, its solid fill (the same token) under a white label (white
  /// on every hue for now), and its subtle fill, the color at `opacity-low`
  /// over the page. The increased-contrast schemes start from their
  /// scheme's default, keep its OKLCH hue and move only lightness, to the
  /// nearest at which it reads at 7:1 on the page, with the most chroma sRGB
  /// allows there; their subtle fills carry base text at 7:1.
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

    /// Gray: middle gray, Munsell value 5.5 (ISCC–NBS 265 medium gray),
    /// achromatic.
    public static let grayValue = 5.5

    /// Every name the tokens carry, in order.
    public static var names: [String] { hueNames + ["gray"] }

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

    /// The gamut cusp at a hue: the lightness of most chroma, and that chroma.
    public static func cusp(h: Double) -> OKLCH {
      var a = 0.0, b = 1.0
      for _ in 0..<90 {
        let m1 = a + (b - a) / 3, m2 = b - (b - a) / 3
        if maxChroma(l: m1, h: h) < maxChroma(l: m2, h: h) { a = m1 } else { b = m2 }
      }
      let l = (a + b) / 2
      return OKLCH(l, maxChroma(l: l, h: h), h)
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

    /// A name's color in light: the cusp at its hue (gray its own).
    static func base(_ name: String) -> OKLCH {
      name == "gray" ? gray : cusp(h: hue(name))
    }

    /// A name's color in dark: light's mirrored (user, 2026-10-11)—the same
    /// hue, the lightness at which it contrasts with black as light's does
    /// with white, with the most chroma sRGB allows there. Each color then
    /// reads alike in both schemes. Of the written colors around that
    /// lightness, the one whose contrast is nearest light's.
    static func mirrored(_ name: String) -> OKLCH {
      let light = base(name)
      let target = contrast(light, OKLCH(1, 0, 0))
      func at(_ l: Double) -> OKLCH {
        light.c == 0 ? OKLCH(l, 0, 0) : OKLCH(l, maxChroma(l: l, h: light.h), light.h)
      }
      func onBlack(_ c: OKLCH) -> Double {
        let r = linearSRGB(c)
        let clamp = { (x: Double) in min(1, max(0, x)) }
        let y = 0.2126 * clamp(r.r) + 0.7152 * clamp(r.g) + 0.0722 * clamp(r.b)
        return (y + 0.05) / 0.05
      }
      var low = 0.0, high = 1.0
      for _ in 0..<60 {
        let mid = (low + high) / 2
        if onBlack(at(mid)) < target { low = mid } else { high = mid }
      }
      var best = at(high)
      for step in -20...20 {
        let candidate = at(min(1, max(0, high + Double(step) * 0.0005)))
        if abs(contrast(candidate, OKLCH(0, 0, 0)) - target) < abs(contrast(best, OKLCH(0, 0, 0)) - target) {
          best = candidate
        }
      }
      return best
    }

    /// A scheme's default color: light's own, or dark's mirrored.
    static func start(_ name: String, _ scheme: Scheme) -> OKLCH {
      scheme.isDark ? mirrored(name) : base(name)
    }

    /// The hex a name is written as in a scheme.
    public static func hex(_ name: String, _ scheme: Scheme) -> String {
      hex(color(name, scheme))
    }

    /// The color of a name in a scheme.
    public static func color(_ name: String, _ scheme: Scheme) -> OKLCH {
      let base = start(name, scheme)
      guard scheme.isMoreContrast else { return base }
      // Lighter or darker toward more contrast with the page.
      return nearest(from: base, darker: !scheme.isDark) { contrast($0, scheme.page) >= moreContrastMinimum }
    }

    /// The subtle fill of the increased-contrast schemes: the color's hue,
    /// base text on it at 7:1, the lightness nearest the color's.
    public static func moreContrastSubtle(_ name: String, _ scheme: Scheme) -> OKLCH {
      let base = start(name, scheme)
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
