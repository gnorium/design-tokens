#if canImport(SwiftUI)
import SwiftUI

/// Gnorium's colors for its iOS and macOS apps: the web's named colors
/// (`NamedColors`), read from the same rule, so the apps and the site never
/// drift. Each in its four appearances: light and dark, and their increased
/// contrast.
public enum AppleConstants {
    // Extreme / Canvas Colors
    public static let extreme = Color(hex: 0xFFFFFF)
    public static let extremeInverted = Color(hex: 0x000000)

    /// A named color in its four appearances.
    public struct SchemeColor: Sendable {
        public let light: Color
        public let dark: Color
        public let increasedContrastLight: Color
        public let increasedContrastDark: Color

        init(_ name: String) {
            func color(_ scheme: NamedColors.Scheme) -> Color {
                // Display P3, as on the web (user, 2026-10-14: P3 only).
                let (r, g, b) = NamedColors.displayP3(NamedColors.color(name, scheme))
                return Color(.displayP3, red: r, green: g, blue: b, opacity: 1)
            }
            light = color(.light)
            dark = color(.dark)
            increasedContrastLight = color(.lightMoreContrast)
            increasedContrastDark = color(.darkMoreContrast)
        }
    }

    public static let red = SchemeColor("red")
    public static let orange = SchemeColor("orange")
    public static let yellow = SchemeColor("yellow")
    public static let lime = SchemeColor("lime")
    public static let green = SchemeColor("green")
    public static let mint = SchemeColor("mint")
    public static let cyan = SchemeColor("cyan")
    public static let blue = SchemeColor("blue")
    public static let indigo = SchemeColor("indigo")
    public static let violet = SchemeColor("violet")
    public static let magenta = SchemeColor("magenta")
    public static let pink = SchemeColor("pink")
    public static let gray = SchemeColor("gray")
}

private extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex & 0xFF0000) >> 16) / 255.0
        let g = Double((hex & 0x00FF00) >> 8) / 255.0
        let b = Double(hex & 0x0000FF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}
#endif
