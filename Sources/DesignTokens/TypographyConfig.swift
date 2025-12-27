import WebTypes

// MARK: - Typography Configuration
public struct TypographyConfig {
	public let fontSans: String
	public let fontSansItalic: String
	public let fontSerif: String
	public let fontSerifItalic: String
	public let fontMono: String

	public init(
		fontSans: String,
		fontSansItalic: String,
		fontSerif: String,
		fontSerifItalic: String,
		fontMono: String
	) {
		self.fontSans = fontSans
		self.fontSansItalic = fontSansItalic
		self.fontSerif = fontSerif
		self.fontSerifItalic = fontSerifItalic
		self.fontMono = fontMono
	}
}
