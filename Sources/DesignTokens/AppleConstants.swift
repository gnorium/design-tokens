#if canImport(SwiftUI)
import SwiftUI

public enum AppleConstants {
    // Extreme / Canvas Colors
    public static let extreme = Color(hex: 0xFFFFFF)
    public static let extremeInverted = Color(hex: 0x000000)
    
    // Core OKLCH/sRGB gamut peak representations (Apple HIG Colors)
    public static let systemRed = Color(hex: 0xFF3B30)
    public static let systemOrange = Color(hex: 0xFF9500)
    public static let systemYellow = Color(hex: 0xFFCC00)
    public static let systemGreen = Color(hex: 0x34C759)
    public static let systemMint = Color(hex: 0x00C7BE)
    public static let systemTeal = Color(hex: 0x30B0C7)
    public static let systemCyan = Color(hex: 0x32ADE6)
    public static let systemBlue = Color(hex: 0x007AFF)
    public static let systemIndigo = Color(hex: 0x5856D6)
    public static let systemPurple = Color(hex: 0xAF52DE)
    public static let systemPink = Color(hex: 0xFF2D55)
    public static let systemBrown = Color(hex: 0xA2845E)
    public static let systemGray = Color(hex: 0x8E8E93)
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
