#if canImport(SwiftUI)
import SwiftUI

public enum AppleConstants {
    // Extreme / Canvas Colors
    public static let extreme = Color(hex: 0xFFFFFF)
    public static let extremeInverted = Color(hex: 0x000000)

    /// One Apple HIG system color in its four appearances, as the HIG's
    /// Specifications table lists them (Color, System colors; iOS, iPadOS
    /// system gray colors): default light and dark, increased contrast light
    /// and dark. Values read 2026-10-11.
    public struct SystemColor: Sendable {
        public let light: Color
        public let dark: Color
        public let increasedContrastLight: Color
        public let increasedContrastDark: Color

        init(light: UInt32, dark: UInt32, increasedContrastLight: UInt32, increasedContrastDark: UInt32) {
            self.light = Color(hex: light)
            self.dark = Color(hex: dark)
            self.increasedContrastLight = Color(hex: increasedContrastLight)
            self.increasedContrastDark = Color(hex: increasedContrastDark)
        }
    }

    // Core OKLCH/sRGB gamut peak representations (Apple HIG Colors)
    public static let systemRed = SystemColor(light: 0xFF383C, dark: 0xFF4245, increasedContrastLight: 0xE9152D, increasedContrastDark: 0xFF6165)
    public static let systemOrange = SystemColor(light: 0xFF8D28, dark: 0xFF9230, increasedContrastLight: 0xC55300, increasedContrastDark: 0xFFA056)
    public static let systemYellow = SystemColor(light: 0xFFCC00, dark: 0xFFD600, increasedContrastLight: 0xA16A00, increasedContrastDark: 0xFEDF43)
    public static let systemGreen = SystemColor(light: 0x34C759, dark: 0x30D158, increasedContrastLight: 0x008932, increasedContrastDark: 0x4AD968)
    public static let systemMint = SystemColor(light: 0x00C8B3, dark: 0x00DAC3, increasedContrastLight: 0x008575, increasedContrastDark: 0x54DFCB)
    public static let systemTeal = SystemColor(light: 0x00C3D0, dark: 0x00D2E0, increasedContrastLight: 0x008198, increasedContrastDark: 0x3BDDEC)
    public static let systemCyan = SystemColor(light: 0x00C0E8, dark: 0x3CD3FE, increasedContrastLight: 0x007EAE, increasedContrastDark: 0x6DD9FF)
    public static let systemBlue = SystemColor(light: 0x0088FF, dark: 0x0091FF, increasedContrastLight: 0x1E6EF4, increasedContrastDark: 0x5CB8FF)
    public static let systemIndigo = SystemColor(light: 0x6155F5, dark: 0x6D7CFF, increasedContrastLight: 0x564ADE, increasedContrastDark: 0xA7AAFF)
    public static let systemPurple = SystemColor(light: 0xCB30E0, dark: 0xDB34F2, increasedContrastLight: 0xB02FC2, increasedContrastDark: 0xEA8DFF)
    public static let systemPink = SystemColor(light: 0xFF2D55, dark: 0xFF375F, increasedContrastLight: 0xE7124D, increasedContrastDark: 0xFF8AC4)
    public static let systemBrown = SystemColor(light: 0xAC7F5E, dark: 0xB78A66, increasedContrastLight: 0x956D51, increasedContrastDark: 0xDBA679)
    public static let systemGray = SystemColor(light: 0x8E8E93, dark: 0x8E8E93, increasedContrastLight: 0x6C6C70, increasedContrastDark: 0xAEAEB2)
    public static let systemGray2 = SystemColor(light: 0xAEAEB2, dark: 0x636366, increasedContrastLight: 0x8E8E93, increasedContrastDark: 0x7C7C80)
    public static let systemGray3 = SystemColor(light: 0xC7C7CC, dark: 0x48484A, increasedContrastLight: 0xAEAEB2, increasedContrastDark: 0x545456)
    public static let systemGray4 = SystemColor(light: 0xD1D1D6, dark: 0x3A3A3C, increasedContrastLight: 0xBCBCC0, increasedContrastDark: 0x444446)
    public static let systemGray5 = SystemColor(light: 0xE5E5EA, dark: 0x2C2C2E, increasedContrastLight: 0xD8D8DC, increasedContrastDark: 0x363638)
    public static let systemGray6 = SystemColor(light: 0xF2F2F7, dark: 0x1C1C1E, increasedContrastLight: 0xEBEBF0, increasedContrastDark: 0x242426)
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
