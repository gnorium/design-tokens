#if SERVER
  import Foundation

  /// Fills that `colorBase` text reads on (user, 2026-10-11): each HIG hue
  /// as a background, derived by one deterministic rule from the HIG color
  /// of its scheme. The glyph (foreground) colors stay exactly HIG; these
  /// are their own family (`backgroundColor{Hue}Readable`).
  ///
  /// The rule: keep the hue; take the most chroma the sRGB gamut allows at
  /// each lightness; and pick the OKLCH lightness nearest the HIG one at
  /// which the fill and the scheme's `colorBase` (`--glyph-gray`) contrast
  /// at least 4.5:1 by WCAG 2 (relative luminance from linear sRGB),
  /// searched outward from the HIG lightness in steps of 0.0005, the
  /// lighter side first at each step.
  public enum ReadableFills {
    public struct OKLCH: Sendable, Equatable {
      public let l: Double
      public let c: Double
      public let h: Double
      public init(_ l: Double, _ c: Double, _ h: Double) {
        self.l = l; self.c = c; self.h = h
      }
    }

    public enum Scheme: CaseIterable, Sendable {
      case light, lightMoreContrast, dark, darkMoreContrast

      /// The scheme's `colorBase`.
      public var base: OKLCH {
        switch self {
        case .light: return OKLCH(0.20, 0.003, 260)
        case .lightMoreContrast: return OKLCH(0.12, 0.004, 260)
        case .dark: return OKLCH(0.96, 0.003, 260)
        case .darkMoreContrast: return OKLCH(0.98, 0.002, 260)
        }
      }

      /// The scheme's HIG colors, by hue (`SourceTokens…CSS`).
      public var hig: [(name: String, color: OKLCH)] {
        switch self {
        case .light:
          return [
            ("red", OKLCH(0.6532, 0.2328, 25.74)), ("orange", OKLCH(0.7533, 0.172, 55.72)),
            ("yellow", OKLCH(0.8652, 0.1768, 90.38)), ("green", OKLCH(0.7303, 0.1944, 147.44)),
            ("mint", OKLCH(0.7471, 0.134, 181.77)), ("teal", OKLCH(0.7446, 0.1268, 203.3)),
            ("cyan", OKLCH(0.7471, 0.136, 219.96)), ("blue", OKLCH(0.6321, 0.2018, 254.09)),
            ("indigo", OKLCH(0.5595, 0.2296, 279.31)), ("purple", OKLCH(0.6216, 0.2629, 322.51)),
            ("pink", OKLCH(0.6497, 0.2383, 17.9)), ("brown", OKLCH(0.6329, 0.0727, 57.23)),
            ("gray", OKLCH(0.55, 0.015, 260)),
          ]
        case .lightMoreContrast:
          return [
            ("red", OKLCH(0.5938, 0.2332, 24.68)), ("orange", OKLCH(0.5812, 0.1634, 46.0)),
            ("yellow", OKLCH(0.5689, 0.1209, 73.51)), ("green", OKLCH(0.5492, 0.1614, 147.42)),
            ("mint", OKLCH(0.5527, 0.1, 180.45)), ("teal", OKLCH(0.5558, 0.0987, 216.06)),
            ("cyan", OKLCH(0.559, 0.1172, 234.14)), ("blue", OKLCH(0.5734, 0.215, 260.57)),
            ("indigo", OKLCH(0.5152, 0.2158, 279.27)), ("purple", OKLCH(0.5635, 0.23, 322.44)),
            ("pink", OKLCH(0.5936, 0.2314, 15.89)), ("brown", OKLCH(0.5684, 0.0653, 55.98)),
            ("gray", OKLCH(0.45, 0.02, 260)),
          ]
        case .dark:
          return [
            ("red", OKLCH(0.662, 0.2246, 25.12)), ("orange", OKLCH(0.7619, 0.167, 57.05)),
            ("yellow", OKLCH(0.8848, 0.1816, 94.9)), ("green", OKLCH(0.7556, 0.2082, 146.98)),
            ("mint", OKLCH(0.7969, 0.1431, 181.65)), ("teal", OKLCH(0.7871, 0.1341, 203.34)),
            ("cyan", OKLCH(0.8076, 0.135, 221.82)), ("blue", OKLCH(0.6515, 0.192, 251.47)),
            ("indigo", OKLCH(0.6413, 0.1928, 274.69)), ("purple", OKLCH(0.6579, 0.2791, 322.41)),
            ("pink", OKLCH(0.6577, 0.2317, 16.02)), ("brown", OKLCH(0.6681, 0.0743, 59.71)),
            ("gray", OKLCH(0.75, 0.015, 260)),
          ]
        case .darkMoreContrast:
          return [
            ("red", OKLCH(0.6982, 0.1926, 22.11)), ("orange", OKLCH(0.7887, 0.1439, 56.51)),
            ("yellow", OKLCH(0.9039, 0.1673, 97.45)), ("green", OKLCH(0.7839, 0.1969, 147.19)),
            ("mint", OKLCH(0.8232, 0.1229, 181.96)), ("teal", OKLCH(0.8237, 0.1287, 204.41)),
            ("cyan", OKLCH(0.8355, 0.1124, 223.72)), ("blue", OKLCH(0.7559, 0.135, 244.31)),
            ("indigo", OKLCH(0.7686, 0.121, 281.6)), ("purple", OKLCH(0.7809, 0.1823, 320.04)),
            ("pink", OKLCH(0.7775, 0.1553, 350.26)), ("brown", OKLCH(0.7642, 0.0867, 61.31)),
            ("gray", OKLCH(0.85, 0.015, 260)),
          ]
        }
      }
    }

    /// The minimum WCAG 2 contrast with `colorBase`.
    public static let minimum = 4.5

    /// Linear sRGB, unclamped.
    public static func linearSRGB(_ color: OKLCH) -> (r: Double, g: Double, b: Double) {
      let radians = color.h * .pi / 180
      let a = color.c * cos(radians)
      let b = color.c * sin(radians)
      let l = pow(color.l + 0.3963377774 * a + 0.2158037573 * b, 3)
      let m = pow(color.l - 0.1055613458 * a - 0.0638541728 * b, 3)
      let s = pow(color.l - 0.0894841775 * a - 1.2914855480 * b, 3)
      return (
        4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
        -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
        -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
      )
    }

    public static func inGamut(_ color: OKLCH) -> Bool {
      let rgb = linearSRGB(color)
      return [rgb.r, rgb.g, rgb.b].allSatisfy { $0 >= -0.000001 && $0 <= 1.000001 }
    }

    /// WCAG 2 relative luminance.
    public static func luminance(_ color: OKLCH) -> Double {
      let rgb = linearSRGB(color)
      let clamp = { (x: Double) in min(1, max(0, x)) }
      return 0.2126 * clamp(rgb.r) + 0.7152 * clamp(rgb.g) + 0.0722 * clamp(rgb.b)
    }

    public static func contrast(_ a: OKLCH, _ b: OKLCH) -> Double {
      let (x, y) = (luminance(a), luminance(b))
      return (max(x, y) + 0.05) / (min(x, y) + 0.05)
    }

    /// The most chroma in gamut at a lightness and hue.
    public static func maxChroma(l: Double, h: Double) -> Double {
      var low = 0.0
      var high = 0.5
      for _ in 0..<40 {
        let mid = (low + high) / 2
        if inGamut(OKLCH(l, mid, h)) { low = mid } else { high = mid }
      }
      return low
    }

    /// The fill for `hig` under `base` text, by the rule above. An
    /// achromatic hue (gray) keeps its own chroma: the most the gamut
    /// allows would make it a blue.
    public static func derive(_ hig: OKLCH, base: OKLCH, achromatic: Bool = false) -> OKLCH {
      var step = 0
      while step <= 2000 {
        for l in step == 0 ? [hig.l] : [hig.l + Double(step) * 0.0005, hig.l - Double(step) * 0.0005]
        where l >= 0 && l <= 1 {
          // Judged as written out: lightness and hue rounded first, the
          // chroma found at them and rounded down, so it stays in gamut.
          let lightness = (l * 10000).rounded(.down) / 10000
          let hue = (hig.h * 100).rounded() / 100
          let most = (maxChroma(l: lightness, h: hue) * 10000).rounded(.down) / 10000
          let fill = OKLCH(lightness, achromatic ? min(hig.c, most) : most, hue)
          if contrast(fill, base) >= minimum { return fill }
        }
        step += 1
      }
      return rounded(hig)
    }

    static func rounded(_ color: OKLCH) -> OKLCH {
      func four(_ x: Double) -> Double { (x * 10000).rounded(.down) / 10000 }
      return OKLCH(four(color.l), four(color.c), (color.h * 100).rounded() / 100)
    }

    /// Every hue's fill in `scheme`.
    public static func fills(_ scheme: Scheme) -> [(name: String, color: OKLCH)] {
      scheme.hig.map { ($0.name, derive($0.color, base: scheme.base, achromatic: $0.name == "gray")) }
    }
  }
#endif
