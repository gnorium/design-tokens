#if !os(WASI)

import CSSBuilder

// MARK: - Apple Human Interface Guidelines (HIG) - Design Tokens
// https://developer.apple.com/design/human-interface-guidelines/color
// MARK: - Apple HIG System Colors - Light Mode - Less Contrast
@CSSBuilder
public func AppleHIGSystemColorsLightLessCSS() -> [CSS] {
	customProperty("--red-light-less", rgb(255, 56, 60)) // hex(0xFF383C)
	customProperty("--orange-light-less", rgb(255, 141, 40)) // hex(0xFF8D28)
	customProperty("--yellow-light-less", rgb(255, 204, 0)) // hex(0xFFCC00)
	customProperty("--green-light-less", rgb(52, 199, 89)) // hex(0x34C759)
	customProperty("--mint-light-less", rgb(0, 200, 179)) // hex(0x00C8B3)
	customProperty("--teal-light-less", rgb(0, 195, 208)) // hex(0x00C3D0)
	customProperty("--cyan-light-less", rgb(0, 192, 232)) // hex(0x00C0E8)
	customProperty("--blue-light-less", rgb(0, 136, 255)) // hex(0x0088FF)
	customProperty("--indigo-light-less", rgb(97, 85, 245)) // hex(0x6155F5)
	customProperty("--purple-light-less", rgb(203, 48, 224)) // hex(0xCB30E0)
	customProperty("--pink-light-less", rgb(255, 45, 85)) // hex(0xFF2D55)
	customProperty("--brown-light-less", rgb(172, 127, 94)) // hex(0xAC7F5E)

	customProperty("--gray-light-less", rgb(142, 142, 147)) // hex(0x8E8E93)
	customProperty("--gray2-light-less", rgb(174, 174, 178)) // hex(0xAEAEB2)
	customProperty("--gray3-light-less", rgb(199, 199, 204)) // hex(0xC7C7CC)
	customProperty("--gray4-light-less", rgb(209, 209, 214)) // hex(0xD1D1D6)
	customProperty("--gray5-light-less", rgb(229, 229, 234)) // hex(0xE5E5EA)
	customProperty("--gray6-light-less", rgb(242, 242, 247)) // hex(0xF2F2F7)
}

// MARK: - Apple HIG System Colors - Light Mode - More Contrast
@CSSBuilder
public func AppleHIGSystemColorsLightMoreCSS() -> [CSS] {
	customProperty("--red-light-more", rgb(233, 21, 45)) // hex(0xE9152D)
	customProperty("--orange-light-more", rgb(197, 83, 0)) // hex(0xC55300)
	customProperty("--yellow-light-more", rgb(161, 106, 0)) // hex(0xA16A00)
	customProperty("--green-light-more", rgb(0, 137, 50)) // hex(0x008932)
	customProperty("--mint-light-more", rgb(0, 133, 117)) // hex(0x008575)
	customProperty("--teal-light-more", rgb(0, 129, 152)) // hex(0x008198)
	customProperty("--cyan-light-more", rgb(0, 126, 174)) // hex(0x007EAE)
	customProperty("--blue-light-more", rgb(30, 110, 244)) // hex(0x1E6EF4)
	customProperty("--indigo-light-more", rgb(86, 74, 222)) // hex(0x564ADE)
	customProperty("--purple-light-more", rgb(176, 47, 194)) // hex(0xB02FC2)
	customProperty("--pink-light-more", rgb(231, 18, 77)) // hex(0xE7124D)
	customProperty("--brown-light-more", rgb(149, 109, 81)) // hex(0x956D51)

	customProperty("--gray-light-more", rgb(108, 108, 112)) // hex(0x6C6C70)
	customProperty("--gray2-light-more", rgb(142, 142, 147)) // hex(0x8E8E93)
	customProperty("--gray3-light-more", rgb(174, 174, 178)) // hex(0xAEAEB2)
	customProperty("--gray4-light-more", rgb(188, 188, 192)) // hex(0xBCBCC0)
	customProperty("--gray5-light-more", rgb(216, 216, 220)) // hex(0xD8D8DC)
	customProperty("--gray6-light-more", rgb(235, 235, 240)) // hex(0xEBEBF0)
}
	
// MARK: - Apple HIG System Colors - Dark Mode - Less Contrast
@CSSBuilder
public func AppleHIGSystemColorsDarkLessCSS() -> [CSS] {
	customProperty("--red-dark-less", rgb(255, 66, 69)) // hex(0xFF4245)
	customProperty("--orange-dark-less", rgb(255, 146, 48)) // hex(0xFF9230)
	customProperty("--yellow-dark-less", rgb(255, 214, 0)) // hex(0xFFD600)
	customProperty("--green-dark-less", rgb(48, 209, 88)) // hex(0x30D158)
	customProperty("--mint-dark-less", rgb(0, 218, 195)) // hex(0x00DAC3)
	customProperty("--teal-dark-less", rgb(0, 210, 224)) // hex(0x00D2E0)
	customProperty("--cyan-dark-less", rgb(60, 211, 254)) // hex(0x3CD3FE)
	customProperty("--blue-dark-less", rgb(0, 145, 255)) // hex(0x0091FF)
	customProperty("--indigo-dark-less", rgb(109, 124, 255)) // hex(0x6D7CFF)
	customProperty("--purple-dark-less", rgb(219, 52, 242)) // hex(0xDB34F2)
	customProperty("--pink-dark-less", rgb(255, 55, 95)) // hex(0xFF375F)
	customProperty("--brown-dark-less", rgb(183, 138, 102)) // hex(0xB78A66)

	customProperty("--gray-dark-less", rgb(142, 142, 147)) // hex(0x8E8E93)
	customProperty("--gray2-dark-less", rgb(99, 99, 102)) // hex(0x636366)
	customProperty("--gray3-dark-less", rgb(72, 72, 74)) // hex(0x48484A)
	customProperty("--gray4-dark-less", rgb(58, 58, 60)) // hex(0x3A3A3C)
	customProperty("--gray5-dark-less", rgb(44, 44, 46)) // hex(0x2C2C2E)
	customProperty("--gray6-dark-less", rgb(28, 28, 30)) // hex(0x1C1C1E)
}

// MARK: - Apple HIG System Colors - Dark Mode - More Contrast
@CSSBuilder
public func AppleHIGSystemColorsDarkMoreCSS() -> [CSS] {
	customProperty("--red-dark-more", rgb(255, 97, 101)) // hex(0xFF6165)
	customProperty("--orange-dark-more", rgb(255, 160, 86)) // hex(0xFFA056)
	customProperty("--yellow-dark-more", rgb(254, 223, 67)) // hex(0xFEDF43)
	customProperty("--green-dark-more", rgb(74, 217, 104)) // hex(0x4AD968)
	customProperty("--mint-dark-more", rgb(84, 223, 203)) // hex(0x54DFCB)
	customProperty("--teal-dark-more", rgb(59, 221, 236)) // hex(0x3BDDEC)
	customProperty("--cyan-dark-more", rgb(109, 217, 255)) // hex(0x6DD9FF)
	customProperty("--blue-dark-more", rgb(92, 184, 255)) // hex(0x5CB8FF)
	customProperty("--indigo-dark-more", rgb(167, 170, 255)) // hex(0xA7AAFF)
	customProperty("--purple-dark-more", rgb(234, 141, 255)) // hex(0xEA8DFF)
	customProperty("--pink-dark-more", rgb(255, 138, 196)) // hex(0xFF8AC4)
	customProperty("--brown-dark-more", rgb(219, 166, 121)) // hex(0xDBA679)

	customProperty("--gray-dark-more", rgb(174, 174, 178)) // hex(0xAEAEB2)
	customProperty("--gray2-dark-more", rgb(124, 124, 128)) // hex(0x7C7C80)
	customProperty("--gray3-dark-more", rgb(84, 84, 86)) // hex(0x545456)
	customProperty("--gray4-dark-more", rgb(68, 68, 70)) // hex(0x444446)
	customProperty("--gray5-dark-more", rgb(54, 54, 56)) // hex(0x363638)
	customProperty("--gray6-dark-more", rgb(36, 36, 38)) // hex(0x242426)
}

// MARK: - Polymorphic Semantic Colors (Light Mode - Less Contrast)
@CSSBuilder
public func AppleHIGSystemColorsLightModeLessContrast() -> [CSS] {
	// Polymorphic foreground colors - light mode, less contrast
	customProperty("--red-fg", redLightLess)
	customProperty("--orange-fg", orangeLightLess)
	customProperty("--yellow-fg", yellowLightLess)
	customProperty("--green-fg", greenLightLess)
	customProperty("--mint-fg", mintLightLess)
	customProperty("--teal-fg", tealLightLess)
	customProperty("--cyan-fg", cyanLightLess)
	customProperty("--blue-fg", blueLightLess)
	customProperty("--indigo-fg", indigoLightLess)
	customProperty("--purple-fg", purpleLightLess)
	customProperty("--pink-fg", pinkLightLess)
	customProperty("--brown-fg", brownLightLess)
	
	// Polymorphic gray foreground colors - light mode, less contrast
	customProperty("--gray-fg", grayLightLess)
	customProperty("--gray2-fg", gray2LightLess)
	customProperty("--gray3-fg", gray3LightLess)
	customProperty("--gray4-fg", gray4LightLess)
	customProperty("--gray5-fg", gray5LightLess)
	customProperty("--gray6-fg", gray6LightLess)

	// Polymorphic background subtle colors - light mode, less contrast (lighter tints)
	customProperty("--red-bg", colorMix(.inSrgb, redLightLess, (.white, perc(90))))
	customProperty("--orange-bg", colorMix(.inSrgb, orangeLightLess, (.white, perc(90))))
	customProperty("--yellow-bg", colorMix(.inSrgb, yellowLightLess, (.white, perc(90))))
	customProperty("--green-bg", colorMix(.inSrgb, greenLightLess, (.white, perc(90))))
	customProperty("--mint-bg", colorMix(.inSrgb, mintLightLess, (.white, perc(90))))
	customProperty("--teal-bg", colorMix(.inSrgb, tealLightLess, (.white, perc(90))))
	customProperty("--cyan-bg", colorMix(.inSrgb, cyanLightLess, (.white, perc(90))))
	customProperty("--blue-bg", colorMix(.inSrgb, blueLightLess, (.white, perc(90))))
	customProperty("--indigo-bg", colorMix(.inSrgb, indigoLightLess, (.white, perc(90))))
	customProperty("--purple-bg", colorMix(.inSrgb, purpleLightLess, (.white, perc(90))))
	customProperty("--pink-bg", colorMix(.inSrgb, pinkLightLess, (.white, perc(90))))
	customProperty("--brown-bg", colorMix(.inSrgb, brownLightLess, (.white, perc(90))))

	// Polymorphic gray background colors - light mode, less contrast
	customProperty("--gray-bg", colorMix(.inSrgb, grayLightLess, (.white, perc(90))))
	customProperty("--gray2-bg", colorMix(.inSrgb, gray2LightLess, (.white, perc(90))))
	customProperty("--gray3-bg", colorMix(.inSrgb, gray3LightLess, (.white, perc(90))))
	customProperty("--gray4-bg", colorMix(.inSrgb, gray4LightLess, (.white, perc(90))))
	customProperty("--gray5-bg", colorMix(.inSrgb, gray5LightLess, (.white, perc(90))))
	customProperty("--gray6-bg", colorMix(.inSrgb, gray6LightLess, (.white, perc(90))))
}

// MARK: - Polymorphic Semantic Colors (Light Mode - More Contrast)
@CSSBuilder
public func AppleHIGSystemColorsLightModeMoreContrast() -> [CSS] {
	// Polymorphic foreground colors - light mode, more contrast (darker for contrast)
	customProperty("--red-fg", redLightMore)
	customProperty("--orange-fg", orangeLightMore)
	customProperty("--yellow-fg", yellowLightMore)
	customProperty("--green-fg", greenLightMore)
	customProperty("--mint-fg", mintLightMore)
	customProperty("--teal-fg", tealLightMore)
	customProperty("--cyan-fg", cyanLightMore)
	customProperty("--blue-fg", blueLightMore)
	customProperty("--indigo-fg", indigoLightMore)
	customProperty("--purple-fg", purpleLightMore)
	customProperty("--pink-fg", pinkLightMore)
	customProperty("--brown-fg", brownLightMore)

	// Polymorphic gray foreground colors - light mode, more contrast (darker for contrast)
	customProperty("--gray-fg", grayLightMore)
	customProperty("--gray2-fg", gray2LightMore)
	customProperty("--gray3-fg", gray3LightMore)
	customProperty("--gray4-fg", gray4LightMore)
	customProperty("--gray5-fg", gray5LightMore)
	customProperty("--gray6-fg", gray6LightMore)
	
	// Polymorphic background subtle colors - light mode, more contrast (LIGHTER/more washed out - INVERTED)
	customProperty("--red-bg", colorMix(.inSrgb, redLightLess, (.white, perc(95))))
	customProperty("--orange-bg", colorMix(.inSrgb, orangeLightLess, (.white, perc(95))))
	customProperty("--yellow-bg", colorMix(.inSrgb, yellowLightLess, (.white, perc(95))))
	customProperty("--green-bg", colorMix(.inSrgb, greenLightLess, (.white, perc(95))))
	customProperty("--mint-bg", colorMix(.inSrgb, mintLightLess, (.white, perc(95))))
	customProperty("--teal-bg", colorMix(.inSrgb, tealLightLess, (.white, perc(95))))
	customProperty("--cyan-bg", colorMix(.inSrgb, cyanLightLess, (.white, perc(95))))
	customProperty("--blue-bg", colorMix(.inSrgb, blueLightLess, (.white, perc(95))))
	customProperty("--indigo-bg", colorMix(.inSrgb, indigoLightLess, (.white, perc(95))))
	customProperty("--purple-bg", colorMix(.inSrgb, purpleLightLess, (.white, perc(95))))
	customProperty("--pink-bg", colorMix(.inSrgb, pinkLightLess, (.white, perc(95))))
	customProperty("--brown-bg", colorMix(.inSrgb, brownLightLess, (.white, perc(95))))

	// Polymorphic gray background colors - light mode, more contrast (LIGHTER/more washed out - INVERTED)
	customProperty("--gray-bg", colorMix(.inSrgb, grayLightLess, (.white, perc(95))))
	customProperty("--gray2-bg", colorMix(.inSrgb, gray2LightLess, (.white, perc(95))))
	customProperty("--gray3-bg", colorMix(.inSrgb, gray3LightLess, (.white, perc(95))))
	customProperty("--gray4-bg", colorMix(.inSrgb, gray4LightLess, (.white, perc(95))))
	customProperty("--gray5-bg", colorMix(.inSrgb, gray5LightLess, (.white, perc(95))))
	customProperty("--gray6-bg", colorMix(.inSrgb, gray6LightLess, (.white, perc(95))))
}

// MARK: - Polymorphic Semantic Colors (Dark Mode - Less Contrast)
@CSSBuilder
public func AppleHIGSystemColorsDarkModeLessContrast() -> [CSS] {
	// Polymorphic foreground colors - dark mode, less contrast
	customProperty("--red-fg", redDarkLess)
	customProperty("--orange-fg", orangeDarkLess)
	customProperty("--yellow-fg", yellowDarkLess)
	customProperty("--green-fg", greenDarkLess)
	customProperty("--mint-fg", mintDarkLess)
	customProperty("--teal-fg", tealDarkLess)
	customProperty("--cyan-fg", cyanDarkLess)
	customProperty("--blue-fg", blueDarkLess)
	customProperty("--indigo-fg", indigoDarkLess)
	customProperty("--purple-fg", purpleDarkLess)
	customProperty("--pink-fg", pinkDarkLess)
	customProperty("--brown-fg", brownDarkLess)
	
	// Polymorphic gray foreground colors - dark mode, less contrast
	customProperty("--gray-fg", grayDarkLess)
	customProperty("--gray2-fg", gray2DarkLess)
	customProperty("--gray3-fg", gray3DarkLess)
	customProperty("--gray4-fg", gray4DarkLess)
	customProperty("--gray5-fg", gray5DarkLess)
	customProperty("--gray6-fg", gray6DarkLess)

	// Polymorphic background subtle colors - dark mode, less contrast (darker shades)
	customProperty("--red-bg", colorMix(.inSrgb, redDarkLess, (.black, perc(90))))
	customProperty("--orange-bg", colorMix(.inSrgb, orangeDarkLess, (.black, perc(90))))
	customProperty("--yellow-bg", colorMix(.inSrgb, yellowDarkLess, (.black, perc(90))))
	customProperty("--green-bg", colorMix(.inSrgb, greenDarkLess, (.black, perc(90))))
	customProperty("--mint-bg", colorMix(.inSrgb, mintDarkLess, (.black, perc(90))))
	customProperty("--teal-bg", colorMix(.inSrgb, tealDarkLess, (.black, perc(90))))
	customProperty("--cyan-bg", colorMix(.inSrgb, cyanDarkLess, (.black, perc(90))))
	customProperty("--blue-bg", colorMix(.inSrgb, blueDarkLess, (.black, perc(90))))
	customProperty("--indigo-bg", colorMix(.inSrgb, indigoDarkLess, (.black, perc(90))))
	customProperty("--purple-bg", colorMix(.inSrgb, purpleDarkLess, (.black, perc(90))))
	customProperty("--pink-bg", colorMix(.inSrgb, pinkDarkLess, (.black, perc(90))))
	customProperty("--brown-bg", colorMix(.inSrgb, brownDarkLess, (.black, perc(90))))

	// Polymorphic gray background colors - dark mode, less contrast (darker shades)
	customProperty("--gray-bg", colorMix(.inSrgb, grayDarkLess, (.black, perc(90))))
	customProperty("--gray2-bg", colorMix(.inSrgb, gray2DarkLess, (.black, perc(90))))
	customProperty("--gray3-bg", colorMix(.inSrgb, gray3DarkLess, (.black, perc(90))))
	customProperty("--gray4-bg", colorMix(.inSrgb, gray4DarkLess, (.black, perc(90))))
	customProperty("--gray5-bg", colorMix(.inSrgb, gray5DarkLess, (.black, perc(90))))
	customProperty("--gray6-bg", colorMix(.inSrgb, gray6DarkLess, (.black, perc(90))))
}

// MARK: - Polymorphic Semantic Colors (Dark Mode - More Contrast)
@CSSBuilder
public func AppleHIGSystemColorsDarkModeMoreContrast() -> [CSS] {
	// Polymorphic foreground colors - dark mode, more contrast (lighter for contrast)
	customProperty("--red-fg", redDarkMore)
	customProperty("--orange-fg", orangeDarkMore)
	customProperty("--yellow-fg", yellowDarkMore)
	customProperty("--green-fg", greenDarkMore)
	customProperty("--mint-fg", mintDarkMore)
	customProperty("--teal-fg", tealDarkMore)
	customProperty("--cyan-fg", cyanDarkMore)
	customProperty("--blue-fg", blueDarkMore)
	customProperty("--indigo-fg", indigoDarkMore)
	customProperty("--purple-fg", purpleDarkMore)
	customProperty("--pink-fg", pinkDarkMore)
	customProperty("--brown-fg", brownDarkMore)

	// Polymorphic gray foreground colors - dark mode, more contrast (lighter for contrast)
	customProperty("--gray-fg", grayDarkMore)
	customProperty("--gray2-fg", gray2DarkMore)
	customProperty("--gray3-fg", gray3DarkMore)
	customProperty("--gray4-fg", gray4DarkMore)
	customProperty("--gray5-fg", gray5DarkMore)
	customProperty("--gray6-fg", gray6DarkMore)
	
	// Polymorphic background subtle colors - dark mode, more contrast (DARKER/more washed out - INVERTED)
	customProperty("--red-bg", colorMix(.inSrgb, redDarkLess, (.black, perc(95))))
	customProperty("--orange-bg", colorMix(.inSrgb, orangeDarkLess, (.black, perc(95))))
	customProperty("--yellow-bg", colorMix(.inSrgb, yellowDarkLess, (.black, perc(95))))
	customProperty("--green-bg", colorMix(.inSrgb, greenDarkLess, (.black, perc(95))))
	customProperty("--mint-bg", colorMix(.inSrgb, mintDarkLess, (.black, perc(95))))
	customProperty("--teal-bg", colorMix(.inSrgb, tealDarkLess, (.black, perc(95))))
	customProperty("--cyan-bg", colorMix(.inSrgb, cyanDarkLess, (.black, perc(95))))
	customProperty("--blue-bg", colorMix(.inSrgb, blueDarkLess, (.black, perc(95))))
	customProperty("--indigo-bg", colorMix(.inSrgb, indigoDarkLess, (.black, perc(95))))
	customProperty("--purple-bg", colorMix(.inSrgb, purpleDarkLess, (.black, perc(95))))
	customProperty("--pink-bg", colorMix(.inSrgb, pinkDarkLess, (.black, perc(95))))
	customProperty("--brown-bg", colorMix(.inSrgb, brownDarkLess, (.black, perc(95))))

	// Polymorphic gray background colors - dark mode, more contrast (DARKER/more washed out - INVERTED)
	customProperty("--gray-bg", colorMix(.inSrgb, grayDarkLess, (.black, perc(95))))
	customProperty("--gray2-bg", colorMix(.inSrgb, gray2DarkLess, (.black, perc(95))))
	customProperty("--gray3-bg", colorMix(.inSrgb, gray3DarkLess, (.black, perc(95))))
	customProperty("--gray4-bg", colorMix(.inSrgb, gray4DarkLess, (.black, perc(95))))
	customProperty("--gray5-bg", colorMix(.inSrgb, gray5DarkLess, (.black, perc(95))))
	customProperty("--gray6-bg", colorMix(.inSrgb, gray6DarkLess, (.black, perc(95))))
}

// MARK: - Wikimedia Codex - Design Tokens - Light Mode - Adapted for Apple HIG
// https://doc.wikimedia.org/codex/latest/design-tokens/color.html
@CSSBuilder
public func WikimediaCodexDesignTokensLightModeLessContrastCSS() -> [CSS] {
	colorScheme(.light).important()
	
	customProperty("--color-base", hex(0x202122))
	customProperty("--color-base-fixed", hex(0x202122))
	customProperty("--color-base--hover", hex(0x404244))
	customProperty("--color-emphasized", hex(0x101418))
	customProperty("--color-subtle", hex(0x54595D))
	customProperty("--color-placeholder", hex(0x72777D))
	customProperty("--color-disabled", hex(0xA2A9B1))
	customProperty("--color-disabled-emphasized", hex(0xA2A9B1))
	customProperty("--color-inverted", hex(0xFFFFFF))
	customProperty("--color-inverted-fixed", hex(0xFFFFFF))
	customProperty("--color-progressive", blueFg) // was hex(0x3366CC)
	customProperty("--color-progressive--hover", colorMix(.inSrgb, blueFg, (.black, perc(10)))) // was hex(0x3056A9)
	customProperty("--color-progressive--active", colorMix(.inSrgb, blueFg, (.black, perc(30)))) // was hex(0x233566)
	customProperty("--color-progressive--focus", blueFg) // was hex(0x3366CC)
	customProperty("--color-destructive", redFg) // was hex(0xBF3C2C)
	customProperty("--color-destructive--hover", colorMix(.inSrgb, redFg, (.black, perc(10)))) // was hex(0x9F3526)
	customProperty("--color-destructive--active", colorMix(.inSrgb, redFg, (.black, perc(30)))) // was hex(0x612419)
	customProperty("--color-destructive--focus", blueFg) // was hex(0x3366CC)
	customProperty("--color-visited", purpleFg) // was hex(0x6A60B0)
	customProperty("--color-visited--hover", colorMix(.inSrgb, purpleFg, (.black, perc(10)))) // was hex(0x534FA3)
	customProperty("--color-visited--active", colorMix(.inSrgb, purpleFg, (.black, perc(30)))) // was hex(0x353262)
	customProperty("--color-destructive--visited", colorMix(.inSrgb, redFg, (.black, perc(10)))) // was hex(0x9F5555)
	customProperty("--color-destructive--visited--hover", colorMix(.inSrgb, redFg, (.black, perc(20)))) // was hex(0x854848)
	customProperty("--color-destructive--visited--active", colorMix(.inSrgb, redFg, (.black, perc(40)))) // was hex(0x512E2E)
	customProperty("--color-error", pinkFg) // was hex(0xBF3C2C)
	customProperty("--color-error--hover", colorMix(.inSrgb, pinkFg, (.black, perc(10)))) // was hex(0x9F3526)
	customProperty("--color-error--active", colorMix(.inSrgb, pinkFg, (.black, perc(30)))) // was hex(0x612419)
	customProperty("--color-warning", orangeFg) // was hex(0x886425)
	customProperty("--color-success", greenFg) // was hex(0x177860)
	customProperty("--color-notice", hex(0x404244))
	customProperty("--color-icon-error", pinkFg) // was hex(0xF54739)
	customProperty("--color-icon-warning", orangeFg) // was hex(0xAB7F2A)
	customProperty("--color-icon-success", greenFg) // was hex(0x099979)
	customProperty("--color-icon-notice", hex(0x72777D))
	customProperty("--color-content-added", greenFg) // was hex(0x006400)
	customProperty("--color-content-removed", redFg) // was hex(0x8B0000)
	customProperty("--opacity-base", 1)
	customProperty("--opacity-medium", 0.65)
	customProperty("--opacity-low", 0.3)
	customProperty("--opacity-transparent", 0)
	customProperty("--filter-invert-icon", 0)
	customProperty("--filter-invert-primary-button-icon", 1)
	customProperty("--background-position-base", .center)
	customProperty("--background-size-search-figure", .cover)
	customProperty("--z-index-bottom", -100)
	customProperty("--z-index-base", 0)
	customProperty("--z-index-above-content", 1)
	customProperty("--z-index-toolbar", 2)
	customProperty("--z-index-dropdown", 50)
	customProperty("--z-index-sticky", 100)
	customProperty("--z-index-fixed", 200)
	customProperty("--z-index-off-canvas-backdrop", 300)
	customProperty("--z-index-off-canvas", 350)
	customProperty("--z-index-overlay-backdrop", 400)
	customProperty("--z-index-overlay", 450)
	customProperty("--z-index-popover", 700)
	customProperty("--z-index-tooltip", 800)
	customProperty("--z-index-toast-notification", 900)
	customProperty("--z-index-top", 9999)
	customProperty("--z-index-stacking-0", 0)
	customProperty("--z-index-stacking-1", 1)
	customProperty("--z-index-stacking-2", 2)
	customProperty("--z-index-stacking-3", 3)
	customProperty("--box-sizing-base", .borderBox)
	customProperty("--size-0", rem(0))
	customProperty("--size-1", rem(0.0625))
	customProperty("--size-2", rem(0.125))
	customProperty("--size-4", rem(0.25))
	customProperty("--size-8", rem(0.5))
	customProperty("--size-12", rem(0.75))
	customProperty("--size-16", rem(1))
	customProperty("--size-20", rem(1.25))
	customProperty("--size-24", rem(1.5))
	customProperty("--size-32", rem(2))
	customProperty("--size-40", rem(2.5))
	customProperty("--size-44", rem(2.75))
	customProperty("--size-48", rem(3))
	customProperty("--size-64", rem(4))
	customProperty("--size-128", rem(8))
	customProperty("--size-192", rem(12))
	customProperty("--size-256", rem(16))
	customProperty("--size-384", rem(24))
	customProperty("--size-448", rem(28))
	customProperty("--size-512", rem(32))
	customProperty("--size-640", rem(40))
	customProperty("--size-896", rem(56))
	customProperty("--size-viewport-width-full", vw(100))
	customProperty("--size-viewport-height-full", vh(100))
	customProperty("--size-absolute-1", px(1))
	customProperty("--size-absolute-9999", px(9999))
	customProperty("--size-content-min", .minContent)
	customProperty("--size-content-fit", .fitContent)
	customProperty("--size-content-max", .maxContent)
	customProperty("--size-third", perc(33.33))
	customProperty("--size-half", perc(50))
	customProperty("--size-full", perc(100))
	customProperty("--size-double", perc(200))
	customProperty("--size-search-figure", rem(2.5))
	customProperty("--max-width-base", CSSKeyword.None.none)
	customProperty("--max-width-breakpoint-mobile", calc("\(px(640)) - \(sizeAbsolute1)"))
	customProperty("--max-width-breakpoint-tablet", calc("\(px(1120)) - \(sizeAbsolute1)"))
	customProperty("--max-width-breakpoint-desktop", calc("\(px(1680)) - \(sizeAbsolute1)"))
	customProperty("--max-width-button", rem(28))
	customProperty("--border-style-base", .solid)
	customProperty("--border-style-dashed", .dashed)
	customProperty("--box-shadow-inset-small", (.inset, 0, 0, 0, px(1)))
	customProperty("--box-shadow-inset-medium", (.inset, 0, 0, 0, px(2)))
	customProperty("--box-shadow-inset-medium-vertical", (.inset, 0, -2, 0, 0))
	customProperty("--box-shadow-outset-small", (0, 0, 0, px(1)))
	customProperty("--box-shadow-outset-small-top", (0, px(-1), 0, 0))
	customProperty("--box-shadow-outset-small-bottom", (0, px(1), 0, 0))
	customProperty("--box-shadow-outset-small-start", (px(-1), 0, 0, 0))
	customProperty("--box-shadow-outset-medium-below", (0, px(4), px(4), 0))
	customProperty("--box-shadow-outset-medium-around", (0, 0, px(8), 0))
	customProperty("--box-shadow-outset-large-below", (0, px(4), px(8), 0))
	customProperty("--box-shadow-outset-large-around", (0, 0, px(16), 0))
	customProperty("--box-shadow-color-base", hex(0xA2A9B1))
	customProperty("--box-shadow-color-progressive--active", colorMix(.inSrgb, blueFg, (.black, perc(30)))) // was hex(0x233566)
	customProperty("--box-shadow-color-progressive--focus", blueFg) // was hex(0x3366CC)
	customProperty("--box-shadow-color-progressive-selected", blueFg) // was hex(0x3366CC)
	customProperty("--box-shadow-color-progressive-selected--hover", colorMix(.inSrgb, blueFg, (.black, perc(10)))) // was hex(0x3056A9)
	customProperty("--box-shadow-color-progressive-selected--active", colorMix(.inSrgb, blueFg, (.black, perc(30)))) // was hex(0x233566)
	customProperty("--box-shadow-color-destructive--focus", blueFg) // was hex(0x3366CC)
	customProperty("--box-shadow-color-inverted", hex(0xFFFFFF))
	customProperty("--box-shadow-color-alpha-base", rgba(0, 0, 0, 0.06))
	customProperty("--box-shadow-color-transparent", .transparent)
	customProperty("--font-family-base", CSSFontFamily.GenericFamily.GenericComplete.sansSerif)
	customProperty("--font-family-system-sans", ("\"-apple-system\"", "\"BlinkMacSystemFont\"", "\"Segoe UI\"", "\"Roboto\"", "\"Inter\"", "\"Helvetica\"", "\"Arial\"", CSSFontFamily.GenericFamily.GenericComplete.sansSerif))
	customProperty("--font-family-sans--fallback", CSSFontFamily.GenericFamily.GenericComplete.sansSerif)
	customProperty("--font-family-serif", ("\"Linux Libertine\"", "\"Georgia\"", "\"Times\"", "\"Source Serif 4\"", CSSFontFamily.GenericFamily.GenericComplete.serif))
	customProperty("--font-family-serif--fallback", CSSFontFamily.GenericFamily.GenericComplete.serif)
	customProperty("--font-family-monospace", ("\"Menlo\"", "\"Consolas\"", "\"Liberation Mono\"", "\"Fira Code\"", "\"Courier New\"", CSSFontFamily.GenericFamily.GenericComplete.monospace))
	customProperty("--font-family-monospace--fallback", CSSFontFamily.GenericFamily.GenericComplete.monospace)
	customProperty("--font-family-heading-main", ("\"Linux Libertine\"", "\"Georgia\"", "\"Times\"", "\"Source Serif 4\"", CSSFontFamily.GenericFamily.GenericComplete.monospace))
	customProperty("--font-size-x-small-12", rem(0.75))
	customProperty("--font-size-small-14", rem(0.875))
	customProperty("--font-size-medium-16", rem(1))
	customProperty("--font-size-large-18", rem(1.125))
	customProperty("--font-size-x-large-20", rem(1.25))
	customProperty("--font-size-xx-large-24", rem(1.5))
	customProperty("--font-size-xxx-large-28", rem(1.75))
	customProperty("--font-weight-hairline", 100)
	customProperty("--font-weight-light", 300)
	customProperty("--font-weight-normal", 400)
	customProperty("--font-weight-semi-bold", 600)
	customProperty("--font-weight-bold", 700)
	customProperty("--line-height-x-small-20", rem(1.25))
	customProperty("--line-height-small-22", rem(1.375))
	customProperty("--line-height-medium-26", rem(1.625))
	customProperty("--line-height-large-28", rem(1.75))
	customProperty("--line-height-x-large-30", rem(1.875))
	customProperty("--line-height-xx-large-34", rem(2.125))
	customProperty("--line-height-xxx-large-38", rem(2.375))
	customProperty("--line-height-content", 1.625)
	customProperty("--text-decoration-none", CSSKeyword.None.none)
	customProperty("--text-decoration-line-through", .lineThrough)
	customProperty("--text-decoration-underline", .underline)
	customProperty("--text-overflow-clip", .clip)
	customProperty("--text-overflow-ellipsis", .ellipsis)
	customProperty("--tab-size-base", 4)
	customProperty("--transform-checkbox-tick--checked", rotate(deg(45)))
	customProperty("--transform-progress-indicator-spinner-start", rotate(deg(-45)))
	customProperty("--transform-progress-indicator-spinner-end", rotate(deg(315)))
	customProperty("--transition-duration-base", ms(100))
	customProperty("--transition-duration-medium", ms(250))
	customProperty("--transition-property-base", (.backgroundColor, .color, .borderColor, .boxShadow))
	customProperty("--transition-property-fade", .opacity)
	customProperty("--transition-property-icon", CSSSingleTransitionProperty.color)
	customProperty("--transition-property-icon-css-only", .backgroundColor)
	customProperty("--transition-property-toggle-switch-grip", (.backgroundColor, .borderColor, .transform))
	customProperty("--transition-timing-function-system", .ease)
	customProperty("--transition-timing-function-user", .easeOut)
	customProperty("--animation-delay-none", ms(0))
	customProperty("--animation-delay-medium", ms(-160))
	customProperty("--animation-delay-slow", ms(-320))
	customProperty("--animation-duration-fast", ms(1000))
	customProperty("--animation-duration-medium", ms(1600))
	customProperty("--animation-duration-slow", ms(2000))
	customProperty("--animation-timing-function-base", .linear)
	customProperty("--animation-timing-function-bouncing", .easeInOut)
	customProperty("--animation-iteration-count-base", .infinite)
	customProperty("--cursor-base", .default)
	customProperty("--cursor-base--disabled", .default)
	customProperty("--cursor-base--hover", .pointer)
	customProperty("--cursor-grab", .grab)
	customProperty("--cursor-grabbing", .grabbing)
	customProperty("--cursor-help", .help)
	customProperty("--cursor-move", .move)
	customProperty("--cursor-not-allowed", .notAllowed)
	customProperty("--cursor-resize-nesw", .neswResize)
	customProperty("--cursor-resize-nwse", .nwseResize)
	customProperty("--cursor-text", .text)
	customProperty("--cursor-zoom-in", .zoomIn)
	customProperty("--cursor-zoom-out", .zoomOut)
	customProperty("--mix-blend-mode-base", .normal)
	customProperty("--mix-blend-mode-blend", .multiply)
	customProperty("--background-color-base", hex(0xFFFFFF))
	customProperty("--background-color-base-fixed", hex(0xFFFFFF))
	customProperty("--background-color-neutral", hex(0xEAECF0))
	customProperty("--background-color-neutral-subtle", hex(0xF8F9FA))
	customProperty("--background-color-interactive", hex(0xEAECF0))
	customProperty("--background-color-interactive--hover", hex(0xDADDE3))
	customProperty("--background-color-interactive--active", hex(0xC8CCD1))
	customProperty("--background-color-interactive-subtle", hex(0xF8F9FA))
	customProperty("--background-color-interactive-subtle--hover", hex(0xEAECF0))
	customProperty("--background-color-interactive-subtle--active", hex(0xDADDE3))
	customProperty("--background-color-disabled", hex(0xDADDE3))
	customProperty("--background-color-disabled-subtle", hex(0xEAECF0))
	customProperty("--background-color-inverted", hex(0x101418))
	customProperty("--background-color-progressive", blueFg) // was hex(0x3366CC)
	customProperty("--background-color-progressive--hover", colorMix(.inSrgb, blueFg, (.black, perc(10)))) // was hex(0x3056A9)
	customProperty("--background-color-progressive--active", colorMix(.inSrgb, blueFg, (.black, perc(20)))) // was hex(0x233566)
	customProperty("--background-color-progressive--focus", blueFg) // was hex(0x3366CC)
	customProperty("--background-color-progressive-subtle", blueBg) // was hex(0xF1F4FD)
	customProperty("--background-color-progressive-subtle--hover", colorMix(.inSrgb, blueBg, (blueFg, perc(5)))) // was hex(0xD9E2FF)
	customProperty("--background-color-progressive-subtle--active", colorMix(.inSrgb, blueBg, (blueFg, perc(10)))) // was hex(0xB6D4FB)
	customProperty("--background-color-destructive", redFg) // was hex(0xBF3C2C) - solid bg uses fg
	customProperty("--background-color-destructive--hover", colorMix(.inSrgb, redFg, (.black, perc(10)))) // was hex(0x9F3526)
	customProperty("--background-color-destructive--active", colorMix(.inSrgb, redFg, (.black, perc(30)))) // was hex(0x612419)
	customProperty("--background-color-destructive--focus", blueFg) // was hex(0x3366CC)
	customProperty("--background-color-destructive-subtle", redBg) // was hex(0xFFE9E5)
	customProperty("--background-color-destructive-subtle--hover", colorMix(.inSrgb, redBg, (redFg, perc(5)))) // was hex(0xFFDAD3)
	customProperty("--background-color-destructive-subtle--active", colorMix(.inSrgb, redBg, (redFg, perc(10)))) // was hex(0xFFC8BD)
	customProperty("--background-color-error", pinkFg) // was hex(0xF54739) - solid bg uses fg
	customProperty("--background-color-error--hover", colorMix(.inSrgb, pinkFg, (.black, perc(10)))) // was hex(0xD74032)
	customProperty("--background-color-error--active", colorMix(.inSrgb, pinkFg, (.black, perc(30)))) // was hex(0xBF3C2C)
	customProperty("--background-color-error-subtle", pinkBg) // was hex(0xFFE9E5)
	customProperty("--background-color-error-subtle--hover", colorMix(.inSrgb, pinkBg, (pinkFg, perc(5)))) // was hex(0xFFDAD3)
	customProperty("--background-color-error-subtle--active", colorMix(.inSrgb, pinkBg, (pinkFg, perc(10)))) // was hex(0xFFC8BD)
	customProperty("--background-color-warning-subtle", yellowBg) // was hex(0xFDF2D5)
	customProperty("--background-color-success-subtle", greenBg) // was hex(0xDFF2EB)
	customProperty("--background-color-notice-subtle", hex(0xEAECF0))
	customProperty("--background-color-content-added", blueBg) // was hex(0xA3D3FF)
	customProperty("--background-color-content-removed", yellowBg) // was hex(0xFFE49C)
	customProperty("--background-color-transparent", .transparent)
	customProperty("--background-color-backdrop-light", rgba(255, 255, 255, 0.65))
	customProperty("--background-color-backdrop-dark", rgba(0, 0, 0, 0.65))
	customProperty("--background-color-button-quiet--hover", rgba(0, 24, 73, 0.027))
	customProperty("--background-color-button-quiet--active", rgba(0, 24, 73, 0.082))
	customProperty("--background-color-input-binary--checked", blueFg) // was hex(0x3366CC)
	customProperty("--background-color-tab-list-item-framed--hover", rgba(255, 255, 255, 0.3))
	customProperty("--background-color-tab-list-item-framed--active", rgba(255, 255, 255, 0.65))
	customProperty("--opacity-icon-base", 0.87)
	customProperty("--opacity-icon-base--hover", 0.74)
	customProperty("--opacity-icon-base--selected", 1)
	customProperty("--opacity-icon-base--disabled", 0.51)
	customProperty("--opacity-icon-placeholder", 0.51)
	customProperty("--opacity-icon-subtle", 0.67)
	customProperty("--min-size-interactive-pointer", px(32))
	customProperty("--min-size-interactive-touch", px(44))
	customProperty("--min-size-search-figure", px(40))
	customProperty("--min-size-icon-x-small", px(10))
	customProperty("--min-size-icon-small", px(14))
	customProperty("--min-size-icon-medium", px(18))
	customProperty("--min-size-input-binary", px(20))
	customProperty("--min-size-input-chip-clear-button", px(20))
	customProperty("--min-size-toggle-switch-grip", px(18))
	customProperty("--min-width-medium", px(256))
	customProperty("--min-width-breakpoint-mobile", px(320))
	customProperty("--min-width-breakpoint-tablet", px(640))
	customProperty("--min-width-breakpoint-desktop", px(1120))
	customProperty("--min-width-breakpoint-desktop-wide", px(1680))
	customProperty("--min-width-toggle-switch", px(42))
	customProperty("--spacing-0", 0)
	customProperty("--spacing-1", px(1))
	customProperty("--spacing-2", px(2))
	customProperty("--spacing-4", px(4))
	customProperty("--spacing-5", px(5))
	customProperty("--spacing-6", px(6))
	customProperty("--spacing-8", px(8))
	customProperty("--spacing-10", px(10))
	customProperty("--spacing-12", px(12))
	customProperty("--spacing-16", px(16))
	customProperty("--spacing-20", px(20))
	customProperty("--spacing-24", px(24))
	customProperty("--spacing-32", px(32))
	customProperty("--spacing-40", px(40))
	customProperty("--spacing-48", px(48))
	customProperty("--spacing-64", px(64))
	customProperty("--spacing-half", perc(50))
	customProperty("--spacing-full", perc(100))
	customProperty("--border-width-base", px(1))
	customProperty("--border-width-thick", px(2))
	customProperty("--border-width-input-radio--checked", px(6))
	customProperty("--border-color-base", hex(0xA2A9B1))
	customProperty("--border-color-emphasized", hex(0x202122))
	customProperty("--border-color-subtle", hex(0xC8CCD1))
	customProperty("--border-color-muted", hex(0xDADDE3))
	customProperty("--border-color-interactive", hex(0x72777D))
	customProperty("--border-color-interactive--hover", hex(0x27292D))
	customProperty("--border-color-interactive--active", hex(0x202122))
	customProperty("--border-color-disabled", hex(0xC8CCD1))
	customProperty("--border-color-inverted", hex(0xFFFFFF))
	customProperty("--border-color-inverted-fixed", hex(0xFFFFFF))
	customProperty("--border-color-progressive", blueFg) // was hex(0x6485D1)
	customProperty("--border-color-progressive--hover", colorMix(.inSrgb, blueFg, (.black, perc(10)))) // was hex(0x3056A9)
	customProperty("--border-color-progressive--active", colorMix(.inSrgb, blueFg, (.black, perc(30)))) // was hex(0x233566)
	customProperty("--border-color-progressive--focus", blueFg) // was hex(0x3366CC)
	customProperty("--border-color-destructive", pinkFg) // was hex(0xF54739)
	customProperty("--border-color-destructive--hover", colorMix(.inSrgb, pinkFg, (.black, perc(10)))) // was hex(0x9F3526)
	customProperty("--border-color-destructive--active", colorMix(.inSrgb, pinkFg, (.black, perc(30)))) // was hex(0x612419)
	customProperty("--border-color-destructive--focus", blueFg) // was hex(0x3366CC)
	customProperty("--border-color-error", pinkFg) // was hex(0xF54739)
	customProperty("--border-color-error--hover", colorMix(.inSrgb, pinkFg, (.black, perc(10)))) // was hex(0x9F3526)
	customProperty("--border-color-error--active", colorMix(.inSrgb, pinkFg, (.black, perc(30)))) // was hex(0x612419)
	customProperty("--border-color-warning", orangeFg) // was hex(0xAB7F2A)
	customProperty("--border-color-warning--hover", colorMix(.inSrgb, orangeFg, (.black, perc(10)))) // was hex(0x735421)
	customProperty("--border-color-warning--active", colorMix(.inSrgb, orangeFg, (.black, perc(30)))) // was hex(0x453217)
	customProperty("--border-color-success", greenFg) // was hex(0x099979)
	customProperty("--border-color-notice", hex(0x72777D))
	customProperty("--border-color-content-added", blueBg) // was hex(0xA3D3FF)
	customProperty("--border-color-content-removed", yellowBg) // was hex(0xFFE49C)
	customProperty("--border-color-transparent", .transparent)
	customProperty("--border-color-divider", hex(0xA2A9B1))
	customProperty("--border-radius-base", px(12))
	customProperty("--border-radius-sharp", 0)
	customProperty("--border-radius-pill", px(9999))
	customProperty("--border-radius-circle", perc(50))
	customProperty("--outline-color-progressive--focus", blueFg) // was hex(0x3366CC)
	customProperty("--min-height-text-area", px(64))
	customProperty("--min-height-table-header", px(40))
	customProperty("--min-height-table-footer", px(40))
	customProperty("--min-height-toggle-switch", px(28))
	customProperty("--max-height-chip", rem(1.375))
	customProperty("--color-link", colorProgressive)
	customProperty("--color-link--hover", colorProgressiveHover)
	customProperty("--color-link--active", colorProgressiveActive)
	customProperty("--color-link--focus", colorProgressiveFocus)
	customProperty("--color-link--visited", colorVisited)
	customProperty("--color-link--visited--hover", colorVisitedHover)
	customProperty("--color-link--visited--active", colorVisitedActive)
	customProperty("--color-link-red", colorDestructive)
	customProperty("--color-link-red--hover", colorDestructiveHover)
	customProperty("--color-link-red--active", colorDestructiveActive)
	customProperty("--color-link-red--focus", colorDestructiveFocus)
	customProperty("--color-link-red--visited", colorDestructiveVisited)
	customProperty("--color-link-red--visited--hover", colorDestructiveVisitedHover)
	customProperty("--color-link-red--visited--active", colorDestructiveVisitedActive)
	customProperty("--size-icon-x-small", calc("\(fontSizeMedium16) - \(px(4))"))
	customProperty("--size-icon-small", fontSizeMedium16)
	customProperty("--size-icon-medium", calc("\(fontSizeMedium16) + \(px(4))"))
	customProperty("--size-toggle-switch-grip", calc("\(fontSizeMedium16) * \(1.25)"))
	customProperty("--box-shadow-small", (boxShadowOutsetSmall, boxShadowColorBase))
	customProperty("--box-shadow-small-top", (boxShadowOutsetSmallTop, boxShadowColorBase))
	customProperty("--box-shadow-small-bottom", (boxShadowOutsetSmallBottom, boxShadowColorBase))
	customProperty("--box-shadow-medium", ((boxShadowOutsetMediumBelow, boxShadowColorAlphaBase), (boxShadowOutsetMediumAround, boxShadowColorAlphaBase)))
	customProperty("--box-shadow-large", ((boxShadowOutsetLargeBelow, boxShadowColorAlphaBase), (boxShadowOutsetLargeAround, boxShadowColorAlphaBase)))
	customProperty("--accent-color-base", blueFg) // was hex(0x3366CC)
	customProperty("--position-offset-border-width-base", "-\(borderWidthBase)")
	customProperty("--spacing-horizontal-button", calc("\(spacing12) - \(borderWidthBase)"))
	customProperty("--spacing-horizontal-button-icon-only", calc("\(spacing6) - \(borderWidthBase)"))
	customProperty("--spacing-horizontal-button-small-icon-only", calc("\(spacing2) - \(borderWidthBase)"))
	customProperty("--spacing-horizontal-button-small", calc("\(spacing6) - \(borderWidthBase)"))
	customProperty("--spacing-horizontal-button-large", calc("\(spacing16) - \(borderWidthBase)"))
	customProperty("--spacing-horizontal-input-text-two-end-icons", calc("\(spacing8) * 2 + \(sizeIconSmall)"))
	customProperty("--spacing-start-typeahead-search-figure", "\(spacing12)")
	customProperty("--spacing-toggle-switch-grip-start", calc("\(fontSizeMedium16) * \(0.375)"))
	customProperty("--spacing-toggle-switch-grip-end", calc("\(fontSizeMedium16) * \(1.25)"))
	customProperty("--border-color-input--hover", borderColorInteractive)
	customProperty("--border-color-input-binary", borderColorInteractive)
	customProperty("--border-color-input-binary--hover", borderColorProgressiveHover)
	customProperty("--border-color-input-binary--active", borderColorProgressiveActive)
	customProperty("--border-color-input-binary--focus", borderColorProgressiveFocus)
	customProperty("--border-color-input-binary--checked", borderColorProgressive)
	customProperty("--border-base", (borderWidthBase, borderStyleBase, borderColorBase))
	customProperty("--border-subtle", (borderWidthBase, borderStyleBase, borderColorSubtle))
	customProperty("--border-progressive", (borderWidthBase, borderStyleBase, borderColorProgressive))
	customProperty("--border-destructive", (borderWidthBase, borderStyleBase, borderColorDestructive))
	customProperty("--border-transparent", (borderWidthBase, borderStyleBase, borderColorTransparent))
	customProperty("--outline-base--focus", (borderWidthBase, .solid, .transparent))
	customProperty("--width-toggle-switch", calc("\(fontSizeMedium16) * \(3)"))
	customProperty("--height-toggle-switch", calc("\(fontSizeMedium16) * 2"))
	customProperty("--spacing-start-typeahead-search-icon", calc("\(spacingStartTypeaheadSearchFigure) + (\(minSizeSearchFigure) - \(minSizeIconMedium)) / 2"))
	customProperty("--spacing-typeahead-search-focus-addition", calc("(\(spacingStartTypeaheadSearchFigure) + \(minSizeSearchFigure)) - (\(minSizeIconMedium) + \(spacing8))"))
}

@CSSBuilder
public func WikimediaCodexDesignTokensLightModeMoreContrastCSS() -> [CSS] {
	// Foreground - Mix with black for more contrast (darker text)
	customProperty("--color-base", colorMix(.inSrgb, hex(0x202122), (.black, perc(20))))
	customProperty("--color-base-fixed", colorMix(.inSrgb, hex(0x202122), (.black, perc(20))))
	customProperty("--color-base--hover", colorMix(.inSrgb, hex(0x404244), (.black, perc(20))))
	customProperty("--color-emphasized", colorMix(.inSrgb, hex(0x101418), (.black, perc(20))))
	customProperty("--color-subtle", colorMix(.inSrgb, hex(0x54595D), (.black, perc(20))))
	customProperty("--color-placeholder", colorMix(.inSrgb, hex(0x72777D), (.black, perc(20))))
	customProperty("--color-disabled", colorMix(.inSrgb, hex(0xA2A9B1), (.black, perc(20))))
	customProperty("--color-progressive", blueFg) // was hex(0x3366CC)
	customProperty("--color-progressive--hover", colorMix(.inSrgb, blueFg, (.black, perc(10)))) // was hex(0x3056A9)
	customProperty("--color-progressive--active", colorMix(.inSrgb, blueFg, (.black, perc(30)))) // was hex(0x233566)
	customProperty("--color-progressive--focus", blueFg) // was hex(0x3366CC)
	customProperty("--color-destructive", redFg) // was hex(0xBF3C2C)
	customProperty("--color-destructive--hover", colorMix(.inSrgb, redFg, (.black, perc(10)))) // was hex(0x9F3526)
	customProperty("--color-destructive--active", colorMix(.inSrgb, redFg, (.black, perc(30)))) // was hex(0x612419)
	customProperty("--color-destructive--focus", blueFg) // was hex(0x3366CC)
	customProperty("--color-visited", purpleFg) // was hex(0x6A60B0)
	customProperty("--color-visited--hover", colorMix(.inSrgb, purpleFg, (.black, perc(10)))) // was hex(0x534FA3)
	customProperty("--color-visited--active", colorMix(.inSrgb, purpleFg, (.black, perc(30)))) // was hex(0x353262)
	customProperty("--color-error", pinkFg) // was hex(0xBF3C2C)
	customProperty("--color-error--hover", colorMix(.inSrgb, pinkFg, (.black, perc(10)))) // was hex(0x9F3526)
	customProperty("--color-error--active", colorMix(.inSrgb, pinkFg, (.black, perc(30)))) // was hex(0x612419)
	customProperty("--color-warning", orangeFg) // was hex(0x886425)
	customProperty("--color-success", greenFg) // was hex(0x177860)
	customProperty("--color-notice", colorMix(.inSrgb, hex(0x404244), (.black, perc(20))))
	
	// Backgrounds - Mix with white for more contrast (lighter backgrounds)
	customProperty("--background-color-base", .white)
	customProperty("--background-color-base-fixed", .white)
	customProperty("--background-color-neutral", colorMix(.inSrgb, hex(0xEAECF0), (.white, perc(20))))
	customProperty("--background-color-neutral-subtle", colorMix(.inSrgb, hex(0xF8F9FA), (.white, perc(20))))
	customProperty("--background-color-interactive", colorMix(.inSrgb, hex(0xEAECF0), (.white, perc(20))))
	customProperty("--background-color-interactive--hover", colorMix(.inSrgb, hex(0xDADDE3), (.white, perc(20))))
	customProperty("--background-color-interactive--active", colorMix(.inSrgb, hex(0xC8CCD1), (.white, perc(20))))
	customProperty("--background-color-inverted", colorMix(.inSrgb, hex(0x101418), (.black, perc(20))))
	customProperty("--background-color-progressive", blueFg) // was hex(0x3366CC)
	customProperty("--background-color-progressive--hover", colorMix(.inSrgb, blueFg, (.black, perc(10)))) // was hex(0x3056A9)
	customProperty("--background-color-progressive--active", colorMix(.inSrgb, blueFg, (.black, perc(20)))) // was hex(0x233566)
	customProperty("--background-color-destructive", redFg) // was hex(0xBF3C2C)
	customProperty("--background-color-destructive--hover", colorMix(.inSrgb, redFg, (.black, perc(10)))) // was hex(0x9F3526)
	customProperty("--background-color-destructive--active", colorMix(.inSrgb, redFg, (.black, perc(20)))) // was hex(0x612419)
	
	// Borders - Mix with black for more visible borders
	customProperty("--border-color-base", colorMix(.inSrgb, hex(0xA2A9B1), (.black, perc(20))))
	customProperty("--border-color-emphasized", colorMix(.inSrgb, hex(0x202122), (.black, perc(20))))
	customProperty("--border-color-subtle", colorMix(.inSrgb, hex(0xC8CCD1), (.black, perc(20))))
	customProperty("--border-color-interactive", colorMix(.inSrgb, hex(0x72777D), (.black, perc(20))))
	customProperty("--border-color-interactive--hover", colorMix(.inSrgb, hex(0x27292D), (.black, perc(20))))
	customProperty("--border-color-interactive--active", colorMix(.inSrgb, hex(0x202122), (.black, perc(20))))
	customProperty("--border-color-progressive", blueFg) // was hex(0x6485D1)
	customProperty("--border-color-progressive--hover", colorMix(.inSrgb, blueFg, (.black, perc(10)))) // was hex(0x3056A9)
	customProperty("--border-color-progressive--active", colorMix(.inSrgb, blueFg, (.black, perc(20)))) // was hex(0x233566)
	customProperty("--border-color-progressive--focus", blueFg) // was hex(0x3366CC)
	customProperty("--border-color-destructive", redFg) // was hex(0xF54739)
	customProperty("--border-color-destructive--hover", colorMix(.inSrgb, redFg, (.black, perc(10)))) // was hex(0x9F3526)
	customProperty("--border-color-destructive--active", colorMix(.inSrgb, redFg, (.black, perc(20)))) // was hex(0x612419)
}

// MARK: - Wikimedia Codex - Design Tokens - Dark Mode - Adapted for Apple HIG
// https://doc.wikimedia.org/codex/latest/design-tokens/color.html
@CSSBuilder
public func WikimediaCodexDesignTokensDarkModeLessContrastCSS() -> [CSS] {
	colorScheme(.dark).important()
	
	customProperty("--color-base", hex(0xEAECF0))
	customProperty("--color-base--hover", hex(0xF8F9FA))
	customProperty("--color-emphasized", hex(0xF8F9FA))
	customProperty("--color-subtle", hex(0xA2A9B1))
	customProperty("--color-disabled", hex(0x54595D))
	customProperty("--color-disabled-emphasized", hex(0x72777D))
	customProperty("--color-inverted", hex(0x101418))
	customProperty("--color-progressive", blueFg) // was hex(0x88A3E8)
	customProperty("--color-progressive--hover", colorMix(.inSrgb, blueFg, (.white, perc(10)))) // was hex(0xA6BBF5)
	customProperty("--color-progressive--active", colorMix(.inSrgb, blueFg, (.white, perc(30)))) // was hex(0xB6D4FB)
	customProperty("--color-destructive", redFg) // was hex(0xFD7865)
	customProperty("--color-destructive--hover", colorMix(.inSrgb, redFg, (.white, perc(10)))) // was hex(0xFEA898)
	customProperty("--color-destructive--active", colorMix(.inSrgb, redFg, (.white, perc(30)))) // was hex(0xFFC8BD)
	customProperty("--color-visited", purpleFg) // was hex(0xA799CD)
	customProperty("--color-visited--hover", colorMix(.inSrgb, purpleFg, (.white, perc(10)))) // was hex(0xC5B9DD)
	customProperty("--color-visited--active", colorMix(.inSrgb, purpleFg, (.white, perc(30)))) // was hex(0xD9D0E9)
	customProperty("--color-destructive--visited", colorMix(.inSrgb, redFg, (.white, perc(10)))) // was hex(0xC99391)
	customProperty("--color-destructive--visited--hover", colorMix(.inSrgb, redFg, (.white, perc(20)))) // was hex(0xDCB5B3)
	customProperty("--color-destructive--visited--active", colorMix(.inSrgb, redFg, (.white, perc(40)))) // was hex(0xE8CECD)
	customProperty("--color-error", pinkFg) // was hex(0xFD7865)
	customProperty("--color-error--hover", colorMix(.inSrgb, pinkFg, (.white, perc(10)))) // was hex(0xFEA898)
	customProperty("--color-error--active", colorMix(.inSrgb, pinkFg, (.white, perc(30)))) // was hex(0xFFC8BD)
	customProperty("--color-warning", orangeFg) // was hex(0xCA982E)
	customProperty("--color-success", greenFg) // was hex(0x2CB491)
	customProperty("--color-notice", hex(0xA2A9B1))
	customProperty("--color-content-added", greenFg) // was hex(0x80CDB3)
	customProperty("--color-content-removed", redFg) // was hex(0xFD7865)
	customProperty("--box-shadow-color-base", hex(0x72777D))
	customProperty("--box-shadow-color-progressive--focus", blueFg) // was hex(0x6485D1)
	customProperty("--box-shadow-color-progressive-selected", blueFg) // was hex(0x88A3E8)
	customProperty("--box-shadow-color-progressive-selected--hover", colorMix(.inSrgb, blueFg, (.white, perc(10)))) // was hex(0xA6BBF5)
	customProperty("--box-shadow-color-progressive-selected--active", colorMix(.inSrgb, blueFg, (.white, perc(30)))) // was hex(0xB6D4FB)
	customProperty("--box-shadow-color-destructive--focus", blueFg) // was hex(0x6485D1)
	customProperty("--box-shadow-color-inverted", hex(0x000000))
	customProperty("--box-shadow-color-alpha-base", rgba(0, 0, 0, 0.87))
	customProperty("--mix-blend-mode-blend", .screen)
	customProperty("--background-color-base", hex(0x101418))
	customProperty("--background-color-neutral", hex(0x27292D))
	customProperty("--background-color-neutral-subtle", hex(0x202122))
	customProperty("--background-color-interactive", hex(0x27292D))
	customProperty("--background-color-interactive--hover", hex(0x404244))
	customProperty("--background-color-interactive--active", hex(0x54595D))
	customProperty("--background-color-interactive-subtle", hex(0x202122))
	customProperty("--background-color-interactive-subtle--hover", hex(0x27292D))
	customProperty("--background-color-interactive-subtle--active", hex(0x404244))
	customProperty("--background-color-disabled", hex(0x404244))
	customProperty("--background-color-disabled-subtle", hex(0x27292D))
	customProperty("--background-color-inverted", hex(0xF8F9FA))
	customProperty("--background-color-progressive--focus", blueFg) // was hex(0x6485D1)
	customProperty("--background-color-progressive-subtle", blueBg) // was hex(0x1B223D)
	customProperty("--background-color-progressive-subtle--hover", colorMix(.inSrgb, blueBg, (blueFg, perc(5)))) // was hex(0x233566)
	customProperty("--background-color-progressive-subtle--active", colorMix(.inSrgb, blueBg, (blueFg, perc(10)))) // was hex(0x3056A9)
	customProperty("--background-color-destructive--focus", blueFg) // was hex(0x6485D1)
	customProperty("--background-color-destructive-subtle", redBg) // was hex(0x3C1A13)
	customProperty("--background-color-destructive-subtle--hover", colorMix(.inSrgb, redBg, (redFg, perc(5)))) // was hex(0x612419)
	customProperty("--background-color-destructive-subtle--active", colorMix(.inSrgb, redBg, (redFg, perc(10)))) // was hex(0x9F3526)
	customProperty("--background-color-error-subtle", pinkBg) // was hex(0x3C1A13)
	customProperty("--background-color-error-subtle--hover", colorMix(.inSrgb, pinkBg, (pinkFg, perc(5)))) // was hex(0x612419)
	customProperty("--background-color-error-subtle--active", colorMix(.inSrgb, pinkBg, (pinkFg, perc(10)))) // was hex(0x9F3526)
	customProperty("--background-color-warning-subtle", hex(0x2D2212))
	customProperty("--background-color-success-subtle", hex(0x132821))
	customProperty("--background-color-notice-subtle", hex(0x27292D))
	customProperty("--background-color-content-added", greenBg) // was hex(0x233566) - wait, greenish bg? 233566 is blue. Wikimedia content added is weird. Apple uses greenBg.
	customProperty("--background-color-content-removed", redBg) // was hex(0x453217)
	customProperty("--background-color-backdrop-light", rgba(0, 0, 0, 0.65))
	customProperty("--background-color-backdrop-dark", rgba(255, 255, 255, 0.65))
	customProperty("--border-color-base", hex(0x72777D))
	customProperty("--border-color-emphasized", hex(0xEAECF0))
	customProperty("--border-color-subtle", hex(0x54595D))
	customProperty("--border-color-muted", hex(0x404244))
	customProperty("--border-color-interactive--hover", hex(0xA2A9B1))
	customProperty("--border-color-interactive--active", hex(0xC8CCD1))
	customProperty("--border-color-disabled", hex(0x54595D))
	customProperty("--border-color-inverted", hex(0x101418))
	customProperty("--border-color-progressive--hover", blueFg) // was hex(0x88A3E8)
	customProperty("--border-color-progressive--active", colorMix(.inSrgb, blueFg, (.white, perc(10)))) // was hex(0xA6BBF5)
	customProperty("--border-color-progressive--focus", blueFg) // was hex(0x6485D1)
	customProperty("--border-color-destructive--hover", redFg) // was hex(0xFD7865)
	customProperty("--border-color-destructive--active", colorMix(.inSrgb, redFg, (.white, perc(10)))) // was hex(0xFEA898)
	customProperty("--border-color-destructive--focus", blueFg) // was hex(0x6485D1)
	customProperty("--border-color-error--hover", pinkFg) // was hex(0xFD7865)
	customProperty("--border-color-error--active", colorMix(.inSrgb, pinkFg, (.white, perc(10)))) // was hex(0xFEA898)
	customProperty("--border-color-warning--hover", orangeFg) // was hex(0xCA982E)
	customProperty("--border-color-warning--active", colorMix(.inSrgb, orangeFg, (.white, perc(10)))) // was hex(0xEDB537)
	customProperty("--border-color-content-added", greenFg) // was hex(0x233566) - again, blue? Wikipedia added is blue? I'll use green for semantic added.
	customProperty("--border-color-content-removed", redFg) // was hex(0x987027)
}

@CSSBuilder
public func WikimediaCodexDesignTokensDarkModeMoreContrastCSS() -> [CSS] {
	// Foreground - Mix with white for more contrast (lighter text in dark mode)
	customProperty("--color-base", colorMix(.inSrgb, hex(0xEAECF0), (.white, perc(20))))
	customProperty("--color-base-fixed", colorMix(.inSrgb, hex(0xEAECF0), (.white, perc(20))))
	customProperty("--color-base--hover", colorMix(.inSrgb, hex(0xF8F9FA), (.white, perc(20))))
	customProperty("--color-emphasized", colorMix(.inSrgb, hex(0xF8F9FA), (.white, perc(20))))
	customProperty("--color-subtle", colorMix(.inSrgb, hex(0xA2A9B1), (.white, perc(20))))
	customProperty("--color-disabled", colorMix(.inSrgb, hex(0x54595D), (.white, perc(20))))
	customProperty("--color-progressive", blueFg) // was hex(0x88A3E8)
	customProperty("--color-progressive--hover", colorMix(.inSrgb, blueFg, (.white, perc(10)))) // was hex(0xA6BBF5)
	customProperty("--color-progressive--active", colorMix(.inSrgb, blueFg, (.white, perc(30)))) // was hex(0xB6D4FB)
	customProperty("--color-destructive", redFg) // was hex(0xFD7865)
	customProperty("--color-destructive--hover", colorMix(.inSrgb, redFg, (.white, perc(10)))) // was hex(0xFEA898)
	customProperty("--color-destructive--active", colorMix(.inSrgb, redFg, (.white, perc(30)))) // was hex(0xFFC8BD)
	customProperty("--color-visited", purpleFg) // was hex(0xA799CD)
	customProperty("--color-visited--hover", colorMix(.inSrgb, purpleFg, (.white, perc(10)))) // was hex(0xC5B9DD)
	customProperty("--color-visited--active", colorMix(.inSrgb, purpleFg, (.white, perc(30)))) // was hex(0xD9D0E9)
	customProperty("--color-error", pinkFg) // was hex(0xFD7865)
	customProperty("--color-error--hover", colorMix(.inSrgb, pinkFg, (.white, perc(10)))) // was hex(0xFEA898)
	customProperty("--color-error--active", colorMix(.inSrgb, pinkFg, (.white, perc(30)))) // was hex(0xFFC8BD)
	customProperty("--color-warning", orangeFg) // was hex(0xCA982E)
	customProperty("--color-success", greenFg) // was hex(0x2CB491)
	customProperty("--color-notice", colorMix(.inSrgb, hex(0xA2A9B1), (.white, perc(20))))
	customProperty("--color-inverted", colorMix(.inSrgb, hex(0x101418), (.black, perc(20))))
	
	// Backgrounds - Mix with black for more contrast (darker backgrounds in dark mode)
	customProperty("--background-color-base", colorMix(.inSrgb, hex(0x101418), (.black, perc(20))))
	customProperty("--background-color-neutral", colorMix(.inSrgb, hex(0x27292D), (.black, perc(20))))
	customProperty("--background-color-neutral-subtle", colorMix(.inSrgb, hex(0x202122), (.black, perc(20))))
	customProperty("--background-color-interactive", colorMix(.inSrgb, hex(0x27292D), (.black, perc(20))))
	customProperty("--background-color-interactive--hover", colorMix(.inSrgb, hex(0x404244), (.black, perc(20))))
	customProperty("--background-color-interactive--active", colorMix(.inSrgb, hex(0x54595D), (.black, perc(20))))
	customProperty("--background-color-inverted", colorMix(.inSrgb, hex(0xF8F9FA), (.white, perc(20))))
	customProperty("--background-color-progressive--focus", blueFg) // was hex(0x6485D1)
	customProperty("--background-color-destructive--focus", blueFg) // was hex(0x6485D1)
	
	// Borders - Mix with white for more visible borders in dark mode
	customProperty("--border-color-base", colorMix(.inSrgb, hex(0x72777D), (.white, perc(20))))
	customProperty("--border-color-emphasized", colorMix(.inSrgb, hex(0xEAECF0), (.white, perc(20))))
	customProperty("--border-color-subtle", colorMix(.inSrgb, hex(0x54595D), (.white, perc(20))))
	customProperty("--border-color-interactive--hover", colorMix(.inSrgb, hex(0xA2A9B1), (.white, perc(20))))
	customProperty("--border-color-interactive--active", colorMix(.inSrgb, hex(0xC8CCD1), (.white, perc(20))))
	customProperty("--border-color-progressive--hover", blueFg) // was hex(0x88A3E8)
	customProperty("--border-color-progressive--active", colorMix(.inSrgb, blueFg, (.white, perc(10)))) // was hex(0xA6BBF5)
	customProperty("--border-color-progressive--focus", blueFg) // was hex(0x6485D1)
	customProperty("--border-color-destructive--hover", redFg) // was hex(0xFD7865)
	customProperty("--border-color-destructive--active", colorMix(.inSrgb, redFg, (.white, perc(10)))) // was hex(0xFEA898)
	customProperty("--border-color-destructive--focus", blueFg) // was hex(0x6485D1)
}

// MARK: - Wikimedia Codex - Style Guide - Colors - Empty
// https://doc.wikimedia.org/codex/latest/style-guide/colors.html
@CSSBuilder
public func WikimediaCodexStyleGuideColorsCSS() -> [CSS] {
}

// MARK: - Wikimedia Meta-Wiki - Brand Colors - Empty
// https://meta.wikimedia.org/wiki/Brand/colours
@CSSBuilder
public func WikimediaMetaWikiBrandColorsCSS() -> [CSS] {
}

#endif

// MARK: - Design Token Constants (Swift references to CSS variables)
// Apple HIG System Colors - Light (Less Vibrant)
public let redLightLess: CSSColor = "var(--red-light-less)"
public let orangeLightLess: CSSColor = "var(--orange-light-less)"
public let yellowLightLess: CSSColor = "var(--yellow-light-less)"
public let greenLightLess: CSSColor = "var(--green-light-less)"
public let mintLightLess: CSSColor = "var(--mint-light-less)"
public let tealLightLess: CSSColor = "var(--teal-light-less)"
public let cyanLightLess: CSSColor = "var(--cyan-light-less)"
public let blueLightLess: CSSColor = "var(--blue-light-less)"
public let indigoLightLess: CSSColor = "var(--indigo-light-less)"
public let purpleLightLess: CSSColor = "var(--purple-light-less)"
public let pinkLightLess: CSSColor = "var(--pink-light-less)"
public let brownLightLess: CSSColor = "var(--brown-light-less)"

public let grayLightLess: CSSColor = "var(--gray-light-less)"
public let gray2LightLess: CSSColor = "var(--gray1-light-less)"
public let gray3LightLess: CSSColor = "var(--gray2-light-less)"
public let gray4LightLess: CSSColor = "var(--gray3-light-less)"
public let gray5LightLess: CSSColor = "var(--gray4-light-less)"
public let gray6LightLess: CSSColor = "var(--gray5-light-less)"

// Apple HIG System Colors - Light (More Vibrant)
public let redLightMore: CSSColor = "var(--red-light-more)"
public let orangeLightMore: CSSColor = "var(--orange-light-more)"
public let yellowLightMore: CSSColor = "var(--yellow-light-more)"
public let greenLightMore: CSSColor = "var(--green-light-more)"
public let mintLightMore: CSSColor = "var(--mint-light-more)"
public let tealLightMore: CSSColor = "var(--teal-light-more)"
public let cyanLightMore: CSSColor = "var(--cyan-light-more)"
public let blueLightMore: CSSColor = "var(--blue-light-more)"
public let indigoLightMore: CSSColor = "var(--indigo-light-more)"
public let purpleLightMore: CSSColor = "var(--purple-light-more)"
public let pinkLightMore: CSSColor = "var(--pink-light-more)"
public let brownLightMore: CSSColor = "var(--brown-light-more)"

public let grayLightMore: CSSColor = "var(--gray-light-more)"
public let gray2LightMore: CSSColor = "var(--gray1-light-more)"
public let gray3LightMore: CSSColor = "var(--gray2-light-more)"
public let gray4LightMore: CSSColor = "var(--gray3-light-more)"
public let gray5LightMore: CSSColor = "var(--gray4-light-more)"
public let gray6LightMore: CSSColor = "var(--gray5-light-more)"

// Apple HIG System Colors - Dark (Less Vibrant)
public let redDarkLess: CSSColor = "var(--red-dark-less)"
public let orangeDarkLess: CSSColor = "var(--orange-dark-less)"
public let yellowDarkLess: CSSColor = "var(--yellow-dark-less)"
public let greenDarkLess: CSSColor = "var(--green-dark-less)"
public let mintDarkLess: CSSColor = "var(--mint-dark-less)"
public let tealDarkLess: CSSColor = "var(--teal-dark-less)"
public let cyanDarkLess: CSSColor = "var(--cyan-dark-less)"
public let blueDarkLess: CSSColor = "var(--blue-dark-less)"
public let indigoDarkLess: CSSColor = "var(--indigo-dark-less)"
public let purpleDarkLess: CSSColor = "var(--purple-dark-less)"
public let pinkDarkLess: CSSColor = "var(--pink-dark-less)"
public let brownDarkLess: CSSColor = "var(--brown-dark-less)"

public let grayDarkLess: CSSColor = "var(--gray-dark-less)"
public let gray2DarkLess: CSSColor = "var(--gray1-dark-less)"
public let gray3DarkLess: CSSColor = "var(--gray2-dark-less)"
public let gray4DarkLess: CSSColor = "var(--gray3-dark-less)"
public let gray5DarkLess: CSSColor = "var(--gray4-dark-less)"
public let gray6DarkLess: CSSColor = "var(--gray5-dark-less)"

// Apple HIG System Colors - Dark (More Vibrant)
public let redDarkMore: CSSColor = "var(--red-dark-more)"
public let orangeDarkMore: CSSColor = "var(--orange-dark-more)"
public let yellowDarkMore: CSSColor = "var(--yellow-dark-more)"
public let greenDarkMore: CSSColor = "var(--green-dark-more)"
public let mintDarkMore: CSSColor = "var(--mint-dark-more)"
public let tealDarkMore: CSSColor = "var(--teal-dark-more)"
public let cyanDarkMore: CSSColor = "var(--cyan-dark-more)"
public let blueDarkMore: CSSColor = "var(--blue-dark-more)"
public let indigoDarkMore: CSSColor = "var(--indigo-dark-more)"
public let purpleDarkMore: CSSColor = "var(--purple-dark-more)"
public let pinkDarkMore: CSSColor = "var(--pink-dark-more)"
public let brownDarkMore: CSSColor = "var(--brown-dark-more)"

public let grayDarkMore: CSSColor = "var(--gray-dark-more)"
public let gray2DarkMore: CSSColor = "var(--gray1-dark-more)"
public let gray3DarkMore: CSSColor = "var(--gray2-dark-more)"
public let gray4DarkMore: CSSColor = "var(--gray3-dark-more)"
public let gray5DarkMore: CSSColor = "var(--gray4-dark-more)"
public let gray6DarkMore: CSSColor = "var(--gray5-dark-more)"

// Polymorphic Foreground Colors (vibrant/pure colors for text, icons, and solid fills)
// Automatically adapt to light/dark mode and contrast preferences
public let redFg: CSSColor = "var(--red-fg)"
public let orangeFg: CSSColor = "var(--orange-fg)"
public let yellowFg: CSSColor = "var(--yellow-fg)"
public let greenFg: CSSColor = "var(--green-fg)"
public let mintFg: CSSColor = "var(--mint-fg)"
public let tealFg: CSSColor = "var(--teal-fg)"
public let cyanFg: CSSColor = "var(--cyan-fg)"
public let blueFg: CSSColor = "var(--blue-fg)"
public let indigoFg: CSSColor = "var(--indigo-fg)"
public let purpleFg: CSSColor = "var(--purple-fg)"
public let pinkFg: CSSColor = "var(--pink-fg)"
public let brownFg: CSSColor = "var(--brown-fg)"

// Polymorphic Background Colors (subtle/washed out colors for tinted backgrounds)
// Automatically adapt to light/dark mode and contrast preferences (INVERTED contrast behavior)
public let redBg: CSSColor = "var(--red-bg)"
public let orangeBg: CSSColor = "var(--orange-bg)"
public let yellowBg: CSSColor = "var(--yellow-bg)"
public let greenBg: CSSColor = "var(--green-bg)"
public let mintBg: CSSColor = "var(--mint-bg)"
public let tealBg: CSSColor = "var(--teal-bg)"
public let cyanBg: CSSColor = "var(--cyan-bg)"
public let blueBg: CSSColor = "var(--blue-bg)"
public let indigoBg: CSSColor = "var(--indigo-bg)"
public let purpleBg: CSSColor = "var(--purple-bg)"
public let pinkBg: CSSColor = "var(--pink-bg)"
public let brownBg: CSSColor = "var(--brown-bg)"

// Polymorphic Gray Foreground Colors (for text, icons, and UI elements)
// Automatically adapt to light/dark mode and contrast preferences
public let grayFg: CSSColor = "var(--gray-fg)"
public let gray2Fg: CSSColor = "var(--gray2-fg)"
public let gray3Fg: CSSColor = "var(--gray3-fg)"
public let gray4Fg: CSSColor = "var(--gray4-fg)"
public let gray5Fg: CSSColor = "var(--gray5-fg)"
public let gray6Fg: CSSColor = "var(--gray6-fg)"

// Polymorphic Gray Background Colors (for subtle backgrounds and surfaces)
// Automatically adapt to light/dark mode and contrast preferences (INVERTED contrast behavior)
public let grayBg: CSSColor = "var(--gray-bg)"
public let gray2Bg: CSSColor = "var(--gray2-bg)"
public let gray3Bg: CSSColor = "var(--gray3-bg)"
public let gray4Bg: CSSColor = "var(--gray4-bg)"
public let gray5Bg: CSSColor = "var(--gray5-bg)"
public let gray6Bg: CSSColor = "var(--gray6-bg)"

// Apple HIG System Colors (adaptive to light/dark/contrast modes)
public let red: CSSColor = "var(--red)"
public let orange: CSSColor = "var(--orange)"
public let yellow: CSSColor = "var(--yellow)"
public let green: CSSColor = "var(--green)"
public let mint: CSSColor = "var(--mint)"
public let teal: CSSColor = "var(--teal)"
public let cyan: CSSColor = "var(--cyan)"
public let blue: CSSColor = "var(--blue)"
public let indigo: CSSColor = "var(--indigo)"
public let purple: CSSColor = "var(--purple)"
public let pink: CSSColor = "var(--pink)"
public let brown: CSSColor = "var(--brown)"

// Apple HIG System Gray Scale (adaptive to light/dark/contrast modes)
public let gray: CSSColor = "var(--gray)"
public let gray2: CSSColor = "var(--gray1)"
public let gray3: CSSColor = "var(--gray2)"
public let gray4: CSSColor = "var(--gray3)"
public let gray5: CSSColor = "var(--gray4)"
public let gray6: CSSColor = "var(--gray5)"
 
public let colorBase: CSSColor = "var(--color-base)"
public let colorBaseFixed: CSSColor = "var(--color-base-fixed)"
public let colorBaseHover: CSSColor = "var(--color-base--hover)"
public let colorEmphasized: CSSColor = "var(--color-emphasized)"
public let colorSubtle: CSSColor = "var(--color-subtle)"
public let colorPlaceholder: CSSColor = "var(--color-placeholder)"
public let colorDisabled: CSSColor = "var(--color-disabled)"
public let colorDisabledEmphasized: CSSColor = "var(--color-disabled-emphasized)"
public let colorInverted: CSSColor = "var(--color-inverted)"
public let colorInvertedFixed: CSSColor = "var(--color-inverted-fixed)"
public let colorProgressive: CSSColor = "var(--color-progressive)"
public let colorProgressiveHover: CSSColor = "var(--color-progressive--hover)"
public let colorProgressiveActive: CSSColor = "var(--color-progressive--active)"
public let colorProgressiveFocus: CSSColor = "var(--color-progressive--focus)"
public let colorDestructive: CSSColor = "var(--color-destructive)"
public let colorDestructiveHover: CSSColor = "var(--color-destructive--hover)"
public let colorDestructiveActive: CSSColor = "var(--color-destructive--active)"
public let colorDestructiveFocus: CSSColor = "var(--color-destructive--focus)"
public let colorVisited: CSSColor = "var(--color-visited)"
public let colorVisitedHover: CSSColor = "var(--color-visited--hover)"
public let colorVisitedActive: CSSColor = "var(--color-visited--active)"
public let colorDestructiveVisited: CSSColor = "var(--color-destructive--visited)"
public let colorDestructiveVisitedHover: CSSColor = "var(--color-destructive--visited--hover)"
public let colorDestructiveVisitedActive: CSSColor = "var(--color-destructive--visited--active)"
public let colorError: CSSColor = "var(--color-error)"
public let colorErrorHover: CSSColor = "var(--color-error--hover)"
public let colorErrorActive: CSSColor = "var(--color-error--active)"
public let colorWarning: CSSColor = "var(--color-warning)"
public let colorSuccess: CSSColor = "var(--color-success)"
public let colorNotice: CSSColor = "var(--color-notice)"
public let colorIconError: CSSColor = "var(--color-icon-error)"
public let colorIconWarning: CSSColor = "var(--color-icon-warning)"
public let colorIconSuccess: CSSColor = "var(--color-icon-success)"
public let colorIconNotice: CSSColor = "var(--color-icon-notice)"
public let colorContentAdded: CSSColor = "var(--color-content-added)"
public let colorContentRemoved: CSSColor = "var(--color-content-removed)"
public let opacityBase: CSSNumber = "var(--opacity-base)"
public let opacityMedium: CSSNumber = "var(--opacity-medium)"
public let opacityLow: CSSNumber = "var(--opacity-low)"
public let opacityTransparent: CSSNumber = "var(--opacity-transparent)"
public let filterInvertIcon: CSSNumber = "var(--filter-invert-icon)"
public let filterInvertPrimaryButtonIcon: CSSNumber = "var(--filter-invert-primary-button-icon)"
public let backgroundPositionBase: CSSBackgroundPosition = "var(--background-position-base)"
public let backgroundSizeSearchFigure: CSSBackgroundSize = "var(--background-size-search-figure)"
public let zIndexBottom: CSSNumber = "var(--z-index-bottom)"
public let zIndexBase: CSSNumber = "var(--z-index-base)"
public let zIndexAboveContent: CSSNumber = "var(--z-index-above-content)"
public let zIndexToolbar: CSSNumber = "var(--z-index-toolbar)"
public let zIndexDropdown: CSSNumber = "var(--z-index-dropdown)"
public let zIndexSticky: CSSNumber = "var(--z-index-sticky)"
public let zIndexFixed: CSSNumber = "var(--z-index-fixed)"
public let zIndexOffCanvasBackdrop: CSSNumber = "var(--z-index-off-canvas-backdrop)"
public let zIndexOffCanvas: CSSNumber = "var(--z-index-off-canvas)"
public let zIndexOverlayBackdrop: CSSNumber = "var(--z-index-overlay-backdrop)"
public let zIndexOverlay: CSSNumber = "var(--z-index-overlay)"
public let zIndexPopover: CSSNumber = "var(--z-index-popover)"
public let zIndexTooltip: CSSNumber = "var(--z-index-tooltip)"
public let zIndexToastNotification: CSSNumber = "var(--z-index-toast-notification)"
public let zIndexTop: CSSNumber = "var(--z-index-top)"
public let zIndexStacking0: CSSNumber = "var(--z-index-stacking-0)"
public let zIndexStacking1: CSSNumber = "var(--z-index-stacking-1)"
public let zIndexStacking2: CSSNumber = "var(--z-index-stacking-2)"
public let zIndexStacking3: CSSNumber = "var(--z-index-stacking-3)"
public let boxSizingBase: CSSBoxSizing = "var(--box-sizing-base)"
public let size0: Length = "var(--size-0)"
public let size1: Length = "var(--size-1)"
public let size2: Length = "var(--size-2)"
public let size4: Length = "var(--size-4)"
public let size8: Length = "var(--size-8)"
public let size12: Length = "var(--size-12)"
public let size16: Length = "var(--size-16)"
public let size20: Length = "var(--size-20)"
public let size24: Length = "var(--size-24)"
public let size32: Length = "var(--size-32)"
public let size40: Length = "var(--size-40)"
public let size44: Length = "var(--size-44)"
public let size48: Length = "var(--size-48)"
public let size64: Length = "var(--size-64)"
public let size128: Length = "var(--size-128)"
public let size192: Length = "var(--size-192)"
public let size256: Length = "var(--size-256)"
public let size384: Length = "var(--size-384)"
public let size448: Length = "var(--size-448)"
public let size512: Length = "var(--size-512)"
public let size640: Length = "var(--size-640)"
public let size896: Length = "var(--size-896)"
public let sizeViewportWidthFull: Length = "var(--size-viewport-width-full)"
public let sizeViewportHeightFull: Length = "var(--size-viewport-height-full)"
public let sizeAbsolute1: Length = "var(--size-absolute-1)"
public let sizeAbsolute9999: Length = "var(--size-absolute-9999)"
public let sizeContentMin: Length = "var(--size-content-min)"
public let sizeContentFit: Length = "var(--size-content-fit)"
public let sizeContentMax: Length = "var(--size-content-max)"
public let sizeThird: Percentage = "var(--size-third)"
public let sizeHalf: Percentage = "var(--size-half)"
public let sizeFull: Percentage = "var(--size-full)"
public let sizeDouble: Percentage = "var(--size-double)"
public let sizeSearchFigure: Length = "var(--size-search-figure)"
public let maxWidthBase: Length = "var(--max-width-base)"
public let maxWidthBreakpointMobile: Length = "var(--max-width-breakpoint-mobile)"
public let maxWidthBreakpointTablet: Length = "var(--max-width-breakpoint-tablet)"
public let maxWidthBreakpointDesktop: Length = "var(--max-width-breakpoint-desktop)"
public let maxWidthButton: Length = "var(--max-width-button)"
public let borderStyleBase: CSSBorder.LineStyle = "var(--border-style-base)"
public let borderStyleDashed: CSSBorder.LineStyle = "var(--border-style-dashed)"
public let boxShadowInsetSmall: CSSSpreadShadow = "var(--box-shadow-inset-small)"
public let boxShadowInsetMedium: CSSSpreadShadow = "var(--box-shadow-inset-medium)"
public let boxShadowInsetMediumVertical: CSSSpreadShadow = "var(--box-shadow-inset-medium-vertical)"
public let boxShadowOutsetSmall: CSSSpreadShadow = "var(--box-shadow-outset-small)"
public let boxShadowOutsetSmallTop: CSSSpreadShadow = "var(--box-shadow-outset-small-top)"
public let boxShadowOutsetSmallBottom: CSSSpreadShadow = "var(--box-shadow-outset-small-bottom)"
public let boxShadowOutsetSmallStart: CSSSpreadShadow = "var(--box-shadow-outset-small-start)"
public let boxShadowOutsetMediumBelow: CSSSpreadShadow = "var(--box-shadow-outset-medium-below)"
public let boxShadowOutsetMediumAround: CSSSpreadShadow = "var(--box-shadow-outset-medium-around)"
public let boxShadowOutsetLargeBelow: CSSSpreadShadow = "var(--box-shadow-outset-large-below)"
public let boxShadowOutsetLargeAround: CSSSpreadShadow = "var(--box-shadow-outset-large-around)"
public let boxShadowColorBase: CSSColor = "var(--box-shadow-color-base)"
public let boxShadowColorProgressiveActive: CSSColor = "var(--box-shadow-color-progressive--active)"
public let boxShadowColorProgressiveFocus: CSSColor = "var(--box-shadow-color-progressive--focus)"
public let boxShadowColorProgressiveSelected: CSSColor = "var(--box-shadow-color-progressive-selected)"
public let boxShadowColorProgressiveSelectedHover: CSSColor = "var(--box-shadow-color-progressive-selected--hover)"
public let boxShadowColorProgressiveSelectedActive: CSSColor = "var(--box-shadow-color-progressive-selected--active)"
public let boxShadowColorDestructiveFocus: CSSColor = "var(--box-shadow-color-destructive--focus)"
public let boxShadowColorInverted: CSSColor = "var(--box-shadow-color-inverted)"
public let boxShadowColorAlphaBase: CSSColor = "var(--box-shadow-color-alpha-base)"
public let boxShadowColorTransparent: CSSColor = "var(--box-shadow-color-transparent)"
public let fontFamilyBase: CSSFontFamily = "var(--font-family-base)"
public let fontFamilySystemSans: CSSFontFamily = "var(--font-family-system-sans)"
public let fontFamilySansFallback: CSSFontFamily = "var(--font-family-sans--fallback)"
public let fontFamilySerif: CSSFontFamily = "var(--font-family-serif)"
public let fontFamilySerifFallback: CSSFontFamily = "var(--font-family-serif--fallback)"
public let fontFamilyMonospace: CSSFontFamily = "var(--font-family-monospace)"
public let fontFamilyMonospaceFallback: CSSFontFamily = "var(--font-family-monospace--fallback)"
public let fontFamilyHeadingMain: CSSFontFamily = "var(--font-family-heading-main)"
public let fontSizeXSmall12: Length = "var(--font-size-x-small-12)"
public let fontSizeSmall14: Length = "var(--font-size-small-14)"
public let fontSizeMedium16: Length = "var(--font-size-medium-16)"
public let fontSizeLarge18: Length = "var(--font-size-large-18)"
public let fontSizeXLarge20: Length = "var(--font-size-x-large-20)"
public let fontSizeXXLarge24: Length = "var(--font-size-xx-large-24)"
public let fontSizeXXXLarge28: Length = "var(--font-size-xxx-large-28)"
public let fontWeightHairline: CSSFontWeight = "var(--font-weight-hairline)"
public let fontWeightLight: CSSFontWeight = "var(--font-weight-light)"
public let fontWeightNormal: CSSFontWeight = "var(--font-weight-normal)"
public let fontWeightSemiBold: CSSFontWeight = "var(--font-weight-semi-bold)"
public let fontWeightBold: CSSFontWeight = "var(--font-weight-bold)"
public let lineHeightXSmall20: Length = "var(--line-height-x-small-20)"
public let lineHeightSmall22: Length = "var(--line-height-small-22)"
public let lineHeightMedium26: Length = "var(--line-height-medium-26)"
public let lineHeightLarge28: Length = "var(--line-height-large-28)"
public let lineHeightXLarge30: Length = "var(--line-height-x-large-30)"
public let lineHeightXXLarge34: Length = "var(--line-height-xx-large-34)"
public let lineHeightXXXLarge38: Length = "var(--line-height-xxx-large-38)"
public let lineHeightContent: Length = "var(--line-height-content)"
public let textDecorationNone: CSSTextDecoration = "var(--text-decoration-none)"
public let textDecorationLineThrough: CSSTextDecoration = "var(--text-decoration-line-through)"
public let textDecorationUnderline: CSSTextDecoration = "var(--text-decoration-underline)"
public let textOverflowClip: CSSTextOverflow = "var(--text-overflow-clip)"
public let textOverflowEllipsis: CSSTextOverflow = "var(--text-overflow-ellipsis)"
public let tabSizeBase: CSSNumber = "var(--tab-size-base)"
public let transformCheckboxTickChecked: CSSTransformFunction = "var(--transform-checkbox-tick--checked)"
public let transformProgressIndicatorSpinnerStart: CSSTransformFunction = "var(--transform-progress-indicator-spinner-start)"
public let transformProgressIndicatorSpinnerEnd: CSSTransformFunction = "var(--transform-progress-indicator-spinner-end)"
public let transitionDurationBase: CSSTime = "var(--transition-duration-base)"
public let transitionDurationMedium: CSSTime = "var(--transition-duration-medium)"
public let transitionPropertyBase: CSSSingleTransitionProperty = "var(--transition-property-base)"
public let transitionPropertyFade: CSSSingleTransitionProperty = "var(--transition-property-fade)"
public let transitionPropertyIcon: CSSSingleTransitionProperty = "var(--transition-property-icon)"
public let transitionPropertyIconCssOnly: CSSSingleTransitionProperty = "var(--transition-property-icon-css-only)"
public let transitionPropertyToggleSwitchGrip: CSSSingleTransitionProperty = "var(--transition-property-toggle-switch-grip)"
public let transitionTimingFunctionSystem: CSSEasingFunction = "var(--transition-timing-function-system)"
public let transitionTimingFunctionUser: CSSEasingFunction = "var(--transition-timing-function-user)"
public let animationDelayNone: CSSTime = "var(--animation-delay-none)"
public let animationDelayMedium: CSSTime = "var(--animation-delay-medium)"
public let animationDelaySlow: CSSTime = "var(--animation-delay-slow)"
public let animationDurationFast: CSSTime = "var(--animation-duration-fast)"
public let animationDurationMedium: CSSTime = "var(--animation-duration-medium)"
public let animationDurationSlow: CSSTime = "var(--animation-duration-slow)"
public let animationTimingFunctionBase: CSSEasingFunction = "var(--animation-timing-function-base)"
public let animationTimingFunctionBouncing: CSSEasingFunction = "var(--animation-timing-function-bouncing)"
public let animationIterationCountBase: CSSNumber = "var(--animation-iteration-count-base)"
public let cursorBase: CSSCursor = "var(--cursor-base)"
public let cursorBaseDisabled: CSSCursor = "var(--cursor-base--disabled)"
public let cursorBaseHover: CSSCursor = "var(--cursor-base--hover)"
public let cursorGrab: CSSCursor = "var(--cursor-grab)"
public let cursorGrabbing: CSSCursor = "var(--cursor-grabbing)"
public let cursorHelp: CSSCursor = "var(--cursor-help)"
public let cursorMove: CSSCursor = "var(--cursor-move)"
public let cursorNotAllowed: CSSCursor = "var(--cursor-not-allowed)"
public let cursorResizeNesw: CSSCursor = "var(--cursor-resize-nesw)"
public let cursorResizeNwse: CSSCursor = "var(--cursor-resize-nwse)"
public let cursorText: CSSCursor = "var(--cursor-text)"
public let cursorZoomIn: CSSCursor = "var(--cursor-zoom-in)"
public let cursorZoomOut: CSSCursor = "var(--cursor-zoom-out)"
public let mixBlendModeBase: CSSBlendMode = "var(--mix-blend-mode-base)"
public let mixBlendModeBlend: CSSBlendMode = "var(--mix-blend-mode-blend)"
public let backgroundColorBase: CSSColor = "var(--background-color-base)"
public let backgroundColorBaseFixed: CSSColor = "var(--background-color-base-fixed)"
public let backgroundColorNeutral: CSSColor = "var(--background-color-neutral)"
public let backgroundColorNeutralSubtle: CSSColor = "var(--background-color-neutral-subtle)"
public let backgroundColorInteractive: CSSColor = "var(--background-color-interactive)"
public let backgroundColorInteractiveHover: CSSColor = "var(--background-color-interactive--hover)"
public let backgroundColorInteractiveActive: CSSColor = "var(--background-color-interactive--active)"
public let backgroundColorInteractiveSubtle: CSSColor = "var(--background-color-interactive-subtle)"
public let backgroundColorInteractiveSubtleHover: CSSColor = "var(--background-color-interactive-subtle--hover)"
public let backgroundColorInteractiveSubtleActive: CSSColor = "var(--background-color-interactive-subtle--active)"
public let backgroundColorDisabled: CSSColor = "var(--background-color-disabled)"
public let backgroundColorDisabledSubtle: CSSColor = "var(--background-color-disabled-subtle)"
public let backgroundColorInverted: CSSColor = "var(--background-color-inverted)"
public let backgroundColorProgressive: CSSColor = "var(--background-color-progressive)"
public let backgroundColorProgressiveHover: CSSColor = "var(--background-color-progressive--hover)"
public let backgroundColorProgressiveActive: CSSColor = "var(--background-color-progressive--active)"
public let backgroundColorProgressiveFocus: CSSColor = "var(--background-color-progressive--focus)"
public let backgroundColorProgressiveSubtle: CSSColor = "var(--background-color-progressive-subtle)"
public let backgroundColorProgressiveSubtleHover: CSSColor = "var(--background-color-progressive-subtle--hover)"
public let backgroundColorProgressiveSubtleActive: CSSColor = "var(--background-color-progressive-subtle--active)"
public let backgroundColorDestructive: CSSColor = "var(--background-color-destructive)"
public let backgroundColorDestructiveHover: CSSColor = "var(--background-color-destructive--hover)"
public let backgroundColorDestructiveActive: CSSColor = "var(--background-color-destructive--active)"
public let backgroundColorDestructiveFocus: CSSColor = "var(--background-color-destructive--focus)"
public let backgroundColorDestructiveSubtle: CSSColor = "var(--background-color-destructive-subtle)"
public let backgroundColorDestructiveSubtleHover: CSSColor = "var(--background-color-destructive-subtle--hover)"
public let backgroundColorDestructiveSubtleActive: CSSColor = "var(--background-color-destructive-subtle--active)"
public let backgroundColorError: CSSColor = "var(--background-color-error)"
public let backgroundColorErrorHover: CSSColor = "var(--background-color-error--hover)"
public let backgroundColorErrorActive: CSSColor = "var(--background-color-error--active)"
public let backgroundColorErrorSubtle: CSSColor = "var(--background-color-error-subtle)"
public let backgroundColorErrorSubtleHover: CSSColor = "var(--background-color-error-subtle--hover)"
public let backgroundColorErrorSubtleActive: CSSColor = "var(--background-color-error-subtle--active)"
public let backgroundColorWarningSubtle: CSSColor = "var(--background-color-warning-subtle)"
public let backgroundColorSuccessSubtle: CSSColor = "var(--background-color-success-subtle)"
public let backgroundColorNoticeSubtle: CSSColor = "var(--background-color-notice-subtle)"
public let backgroundColorContentAdded: CSSColor = "var(--background-color-content-added)"
public let backgroundColorContentRemoved: CSSColor = "var(--background-color-content-removed)"
public let backgroundColorTransparent: CSSColor = "var(--background-color-transparent)"
public let backgroundColorBackdropLight: CSSColor = "var(--background-color-backdrop-light)"
public let backgroundColorBackdropDark: CSSColor = "var(--background-color-backdrop-dark)"
public let backgroundColorButtonQuietHover: CSSColor = "var(--background-color-button-quiet--hover)"
public let backgroundColorButtonQuietActive: CSSColor = "var(--background-color-button-quiet--active)"
public let backgroundColorInputBinaryChecked: CSSColor = "var(--background-color-input-binary--checked)"
public let backgroundColorTabListItemFramedHover: CSSColor = "var(--background-color-tab-list-item-framed--hover)"
public let backgroundColorTabListItemFramedActive: CSSColor = "var(--background-color-tab-list-item-framed--active)"
public let opacityIconBase: CSSNumber = "var(--opacity-icon-base)"
public let opacityIconBaseHover: CSSNumber = "var(--opacity-icon-base--hover)"
public let opacityIconBaseSelected: CSSNumber = "var(--opacity-icon-base--selected)"
public let opacityIconBaseDisabled: CSSNumber = "var(--opacity-icon-base--disabled)"
public let opacityIconPlaceholder: CSSNumber = "var(--opacity-icon-placeholder)"
public let opacityIconSubtle: CSSNumber = "var(--opacity-icon-subtle)"
public let minSizeInteractivePointer: Length = "var(--min-size-interactive-pointer)"
public let minSizeInteractiveTouch: Length = "var(--min-size-interactive-touch)"
public let minSizeSearchFigure: Length = "var(--min-size-search-figure)"
public let minSizeIconXSmall: Length = "var(--min-size-icon-x-small)"
public let minSizeIconSmall: Length = "var(--min-size-icon-small)"
public let minSizeIconMedium: Length = "var(--min-size-icon-medium)"
public let minSizeInputBinary: Length = "var(--min-size-input-binary)"
public let minSizeInputChipClearButton: Length = "var(--min-size-input-chip-clear-button)"
public let minSizeToggleSwitchGrip: Length = "var(--min-size-toggle-switch-grip)"
public let minWidthMedium: Length = "var(--min-width-medium)"
public let minWidthBreakpointMobile: Length = "var(--min-width-breakpoint-mobile)"
public let minWidthBreakpointTablet: Length = "var(--min-width-breakpoint-tablet)"
public let minWidthBreakpointDesktop: Length = "var(--min-width-breakpoint-desktop)"
public let minWidthBreakpointDesktopWide: Length = "var(--min-width-breakpoint-desktop-wide)"
public let minWidthToggleSwitch: Length = "var(--min-width-toggle-switch)"
public let spacing0: Length = "var(--spacing-0)"
public let spacing1: Length = "var(--spacing-1)"
public let spacing2: Length = "var(--spacing-2)"
public let spacing4: Length = "var(--spacing-4)"
public let spacing5: Length = "var(--spacing-5)"
public let spacing6: Length = "var(--spacing-6)"
public let spacing8: Length = "var(--spacing-8)"
public let spacing10: Length = "var(--spacing-10)"
public let spacing12: Length = "var(--spacing-12)"
public let spacing16: Length = "var(--spacing-16)"
public let spacing20: Length = "var(--spacing-20)"
public let spacing24: Length = "var(--spacing-24)"
public let spacing32: Length = "var(--spacing-32)"
public let spacing40: Length = "var(--spacing-40)"
public let spacing48: Length = "var(--spacing-48)"
public let spacing64: Length = "var(--spacing-64)"
public let spacingHalf: Percentage = "var(--spacing-half)"
public let spacingFull: Percentage = "var(--spacing-full)"
public let borderWidthBase: Length = "var(--border-width-base)"
public let borderWidthThick: Length = "var(--border-width-thick)"
public let borderWidthInputRadioChecked: Length = "var(--border-width-input-radio--checked)"
public let borderColorBase: CSSColor = "var(--border-color-base)"
public let borderColorEmphasized: CSSColor = "var(--border-color-emphasized)"
public let borderColorSubtle: CSSColor = "var(--border-color-subtle)"
public let borderColorMuted: CSSColor = "var(--border-color-muted)"
public let borderColorInteractive: CSSColor = "var(--border-color-interactive)"
public let borderColorInteractiveHover: CSSColor = "var(--border-color-interactive--hover)"
public let borderColorInteractiveActive: CSSColor = "var(--border-color-interactive--active)"
public let borderColorDisabled: CSSColor = "var(--border-color-disabled)"
public let borderColorInverted: CSSColor = "var(--border-color-inverted)"
public let borderColorInvertedFixed: CSSColor = "var(--border-color-inverted-fixed)"
public let borderColorProgressive: CSSColor = "var(--border-color-progressive)"
public let borderColorProgressiveHover: CSSColor = "var(--border-color-progressive--hover)"
public let borderColorProgressiveActive: CSSColor = "var(--border-color-progressive--active)"
public let borderColorProgressiveFocus: CSSColor = "var(--border-color-progressive--focus)"
public let borderColorDestructive: CSSColor = "var(--border-color-destructive)"
public let borderColorDestructiveHover: CSSColor = "var(--border-color-destructive--hover)"
public let borderColorDestructiveActive: CSSColor = "var(--border-color-destructive--active)"
public let borderColorDestructiveFocus: CSSColor = "var(--border-color-destructive--focus)"
public let borderColorError: CSSColor = "var(--border-color-error)"
public let borderColorErrorHover: CSSColor = "var(--border-color-error--hover)"
public let borderColorErrorActive: CSSColor = "var(--border-color-error--active)"
public let borderColorWarning: CSSColor = "var(--border-color-warning)"
public let borderColorWarningHover: CSSColor = "var(--border-color-warning--hover)"
public let borderColorWarningActive: CSSColor = "var(--border-color-warning--active)"
public let borderColorSuccess: CSSColor = "var(--border-color-success)"
public let borderColorNotice: CSSColor = "var(--border-color-notice)"
public let borderColorContentAdded: CSSColor = "var(--border-color-content-added)"
public let borderColorContentRemoved: CSSColor = "var(--border-color-content-removed)"
public let borderColorTransparent: CSSColor = "var(--border-color-transparent)"
public let borderColorDivider: CSSColor = "var(--border-color-divider)"
public let borderRadiusBase: Length = "var(--border-radius-base)"
public let borderRadiusSharp: Length = "var(--border-radius-sharp)"
public let borderRadiusPill: Length = "var(--border-radius-pill)"
public let borderRadiusCircle: Percentage = "var(--border-radius-circle)"
public let outlineColorProgressiveFocus: CSSColor = "var(--outline-color-progressive--focus)"
public let minHeightTextArea: Length = "var(--min-height-text-area)"
public let minHeightTableHeader: Length = "var(--min-height-table-header)"
public let minHeightTableFooter: Length = "var(--min-height-table-footer)"
public let minHeightToggleSwitch: Length = "var(--min-height-toggle-switch)"
public let maxHeightChip: Length = "var(--max-height-chip)"
public let colorLink: CSSColor = "var(--color-link)"
public let colorLinkHover: CSSColor = "var(--color-link--hover)"
public let colorLinkActive: CSSColor = "var(--color-link--active)"
public let colorLinkFocus: CSSColor = "var(--color-link--focus)"
public let colorLinkVisited: CSSColor = "var(--color-link--visited)"
public let colorLinkVisitedHover: CSSColor = "var(--color-link--visited--hover)"
public let colorLinkVisitedActive: CSSColor = "var(--color-link--visited--active)"
public let colorLinkRed: CSSColor = "var(--color-link-red)"
public let colorLinkRedHover: CSSColor = "var(--color-link-red--hover)"
public let colorLinkRedActive: CSSColor = "var(--color-link-red--active)"
public let colorLinkRedFocus: CSSColor = "var(--color-link-red--focus)"
public let colorLinkRedVisited: CSSColor = "var(--color-link-red--visited)"
public let colorLinkRedVisitedHover: CSSColor = "var(--color-link-red--visited--hover)"
public let colorLinkRedVisitedActive: CSSColor = "var(--color-link-red--visited--active)"
public let sizeIconXSmall: Length = "var(--size-icon-x-small)"
public let sizeIconSmall: Length = "var(--size-icon-small)"
public let sizeIconMedium: Length = "var(--size-icon-medium)"
public let sizeToggleSwitchGrip: Length = "var(--size-toggle-switch-grip)"
public let boxShadowSmall: CSSSpreadShadow = "var(--box-shadow-small)"
public let boxShadowSmallTop: CSSSpreadShadow = "var(--box-shadow-small-top)"
public let boxShadowSmallBottom: CSSSpreadShadow = "var(--box-shadow-small-bottom)"
public let boxShadowMedium: CSSSpreadShadow = "var(--box-shadow-medium)"
public let boxShadowLarge: CSSSpreadShadow = "var(--box-shadow-large)"
public let accentColorBase: CSSColor = "var(--accent-color-base)"
public let positionOffsetBorderWidthBase: Length = "var(--position-offset-border-width-base)"
public let spacingHorizontalButton: Length = "var(--spacing-horizontal-button)"
public let spacingHorizontalButtonIconOnly: Length = "var(--spacing-horizontal-button-icon-only)"
public let spacingHorizontalButtonSmallIconOnly: Length = "var(--spacing-horizontal-button-small-icon-only)"
public let spacingHorizontalButtonSmall: Length = "var(--spacing-horizontal-button-small)"
public let spacingHorizontalButtonLarge: Length = "var(--spacing-horizontal-button-large)"
public let spacingHorizontalInputTextTwoEndIcons: Length = "var(--spacing-horizontal-input-text-two-end-icons)"
public let spacingStartTypeaheadSearchFigure: Length = "var(--spacing-start-typeahead-search-figure)"
public let spacingToggleSwitchGripStart: Length = "var(--spacing-toggle-switch-grip-start)"
public let spacingToggleSwitchGripEnd: Length = "var(--spacing-toggle-switch-grip-end)"
public let borderColorInputHover: CSSColor = "var(--border-color-input--hover)"
public let borderColorInputBinary: CSSColor = "var(--border-color-input-binary)"
public let borderColorInputBinaryHover: CSSColor = "var(--border-color-input-binary--hover)"
public let borderColorInputBinaryActive: CSSColor = "var(--border-color-input-binary--active)"
public let borderColorInputBinaryFocus: CSSColor = "var(--border-color-input-binary--focus)"
public let borderColorInputBinaryChecked: CSSColor = "var(--border-color-input-binary--checked)"
public let borderBase: CSSBorder = "var(--border-base)"
public let borderSubtle: CSSBorder = "var(--border-subtle)"
public let borderProgressive: CSSBorder = "var(--border-progressive)"
public let borderDestructive: CSSBorder = "var(--border-destructive)"
public let borderTransparent: CSSBorder = "var(--border-transparent)"
public let outlineBaseFocus: CSSBorder = "var(--outline-base--focus)"
public let widthToggleSwitch: Length = "var(--width-toggle-switch)"
public let heightToggleSwitch: Length = "var(--height-toggle-switch)"
public let spacingStartTypeaheadSearchIcon: Length = "var(--spacing-start-typeahead-search-icon)"
public let spacingTypeaheadSearchFocusAddition: Length = "var(--spacing-typeahead-search-focus-addition)"
