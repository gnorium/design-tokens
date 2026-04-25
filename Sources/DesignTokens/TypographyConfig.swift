import WebTypes

// MARK: - Typography Configuration
public struct TypographyConfig {
  public let fontSans: CSSFontFamily
  public let fontSansItalic: CSSFontFamily
  public let fontSerif: CSSFontFamily
  public let fontSerifItalic: CSSFontFamily
  public let fontMono: CSSFontFamily

  public init(
    fontSans: CSSFontFamily,
    fontSansItalic: CSSFontFamily,
    fontSerif: CSSFontFamily,
    fontSerifItalic: CSSFontFamily,
    fontMono: CSSFontFamily
  ) {
    self.fontSans = fontSans
    self.fontSansItalic = fontSansItalic
    self.fontSerif = fontSerif
    self.fontSerifItalic = fontSerifItalic
    self.fontMono = fontMono
  }
}
