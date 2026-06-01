import WebTypes

// MARK: - Typography Configuration
public struct TypographyConfig {
  public let fontSans: CSS.FontFamily
  public let fontSansItalic: CSS.FontFamily
  public let fontSerif: CSS.FontFamily
  public let fontSerifItalic: CSS.FontFamily
  public let fontMono: CSS.FontFamily

  public init(
    fontSans: CSS.FontFamily,
    fontSansItalic: CSS.FontFamily,
    fontSerif: CSS.FontFamily,
    fontSerifItalic: CSS.FontFamily,
    fontMono: CSS.FontFamily
  ) {
    self.fontSans = fontSans
    self.fontSansItalic = fontSansItalic
    self.fontSerif = fontSerif
    self.fontSerifItalic = fontSerifItalic
    self.fontMono = fontMono
  }
}
