import WebTypes

// MARK: - Typography Configuration
public struct TypographyConfig {
	public let fontSans: (any CSSValue)...
	public let fontSansItalic: (any CSSValue)...
	public let fontSerif: (any CSSValue)...
	public let fontSerifItalic: (any CSSValue)...
	public let fontMono: (any CSSValue)...

	public init(
		fontSans: (any CSSValue)...,
		fontSansItalic: (any CSSValue)...,
		fontSerif: (any CSSValue)...,
		fontSerifItalic: (any CSSValue)...,
		fontMono: (any CSSValue)...
	) {
		self.fontSans = fontSans
		self.fontSansItalic = fontSansItalic
		self.fontSerif = fontSerif
		self.fontSerifItalic = fontSerifItalic
		self.fontMono = fontMono
	}
}
