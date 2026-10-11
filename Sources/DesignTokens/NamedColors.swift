#if SERVER
  import Foundation

  /// Gnorium's named colors (user, 2026-10-11; design-notes/iscc-nbs-vivid-cusps.html):
  /// the ISCC–NBS names, each at the sRGB gamut cusp—the most chromatic color
  /// sRGB reaches—of its vivid centroid's hue, and white, gray and black.
  ///
  /// Each hue is the OKLCH hue of the name's "vivid" ISCC–NBS centroid (Kelly,
  /// "Central Notations for the Revised ISCC-NBS Color-Name Blocks", J. Res.
  /// NBS 61(5), 1958), its Munsell notation converted through the Munsell
  /// renotation (Newhall, Nickerson & Judd, JOSA 33, 1943; xyY under
  /// Illuminant C, linear in xy between the tabulated hues, values and
  /// chromas), adapted to D65 by Bradford, then to OKLab. The tests derive the
  /// hues from those renotation entries and reproduce every hex here.
  ///
  /// The default schemes use each cusp as it is, light and dark alike: a
  /// color, its solid fill (the same token) under a white label (user,
  /// 2026-10-11: white on all eight for now), and its subtle fill, the color
  /// at `opacity-low` over the page. The increased-contrast schemes move only lightness, to
  /// the nearest at which the color reads at 7:1 on the page, with the most
  /// chroma sRGB allows there; their subtle fills carry base text at 7:1.
  public enum NamedColors {
    public struct OKLCH: Sendable, Equatable {
      public let l: Double
      public let c: Double
      public let h: Double
      public init(_ l: Double, _ c: Double, _ h: Double) { self.l = l; self.c = c; self.h = h }
    }

    /// A hue name and the vivid centroid its hue is taken from.
    public struct Hue: Sendable {
      public let name: String
      /// ISCC–NBS centroid number and Munsell notation.
      public let centroid: Int
      public let notation: String
      /// Its OKLCH hue via the renotation, in degrees.
      public let h: Double
    }

    public static let hues: [Hue] = [
      // Pink is vivid reddish purple's (user, 2026-10-11): vivid pink's own
      // cusp (#FF0059) read as a second red beside red's.
      Hue(name: "pink", centroid: 236, notation: "1.0RP 4/19", h: 337.4921),
      Hue(name: "red", centroid: 11, notation: "5R 4/15", h: 20.2664),
      Hue(name: "orange", centroid: 48, notation: "4.5YR 6.6/16", h: 58.5412),
      Hue(name: "yellow", centroid: 82, notation: "4.0Y 7.8/14.5", h: 92.9164),
      Hue(name: "green", centroid: 139, notation: "6.5G 5.2/18", h: 170.5929),
      Hue(name: "blue", centroid: 176, notation: "3.0PB 4.2/15", h: 235.7221),
      Hue(name: "violet", centroid: 205, notation: "1.0P 2.7/21", h: 302.7675),
      Hue(name: "purple", centroid: 216, notation: "6.0P 3.5/20", h: 321.005),
    ]

    /// Gray: ISCC–NBS 265 medium gray, Munsell value 5.5, achromatic.
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

    /// The color of a name in a scheme.
    public static func color(_ name: String, _ scheme: Scheme) -> OKLCH {
      let base = name == "gray" ? gray : cusp(h: hues.first { $0.name == name }!.h)
      guard scheme.isMoreContrast else { return base }
      // Lighter or darker toward more contrast with the page.
      return nearest(from: base, darker: !scheme.isDark) { contrast($0, scheme.page) >= moreContrastMinimum }
    }

    /// The subtle fill of the increased-contrast schemes: the color's hue,
    /// base text on it at 7:1, the lightness nearest the color's.
    public static func moreContrastSubtle(_ name: String, _ scheme: Scheme) -> OKLCH {
      let base = name == "gray" ? gray : cusp(h: hues.first { $0.name == name }!.h)
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
