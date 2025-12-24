# DesignTokens, as used in [gnorium.com](https://gnorium.com)

Universal design tokens for Swift web development based on Apple Human Interface Guidelines and Wikimedia Codex.

## Overview

DesignTokens provides CSS custom property definitions and Swift constants for creating consistent, accessible web interfaces. Includes complete implementations of Apple HIG system colors and Wikimedia Codex design system.

## Features

- **Apple HIG System Colors**: Complete light/dark mode color palettes with contrast variants
- **Wikimedia Codex Design System**: Comprehensive UI design tokens for colors, spacing, typography, and more
- **CSS Generation**: Functions to generate complete CSS custom property definitions
- **Swift Constants**: Type-safe references to CSS variables for use in Swift DSL builders
- **Accessibility**: Built-in support for light/dark modes and contrast preferences

## Installation

### Swift Package Manager

Add DesignTokens to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/gnorium/design-tokens", from: "1.0.0")
]
```

Then add it to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "DesignTokens", package: "design-tokens")
    ]
)
```

## Usage

### Generating CSS

```swift
import DesignTokens
import CSSBuilder

// Generate Apple HIG system colors CSS
let css = AppleHIGSystemColorsLightLessCSS()

// Generate Wikimedia Codex design tokens CSS
let codexCSS = WikimediaCodexDesignTokensLightModeLessContrastCSS()
```

### Using Design Tokens in Swift

```swift
import DesignTokens

// Use color tokens
div {
    "Hello World"
}
.style {
    color(blueFg)
    backgroundColor(gray6Bg)
    padding(spacing16)
    fontSize(fontSizeMedium16)
}
```

## Design Systems

### Apple Human Interface Guidelines

Complete implementation of Apple's system colors with support for:
- Light and dark modes
- Increased and decreased contrast variants
- Polymorphic foreground/background color pairs
- Full gray scale (6 shades)

### Wikimedia Codex

Comprehensive design system tokens including:
- Color semantics (progressive, destructive, error, warning, success)
- Spacing scale (rem-based)
- Typography (font families, sizes, weights, line heights)
- Interactive states (hover, active, focus, disabled)
- Z-index layering
- Border radius and shadows
- Cursor styles
- Transitions and animations

## Requirements

- Swift 6.0+
- Depends on web-builders for CSS generation

## License

Apache License 2.0 - See [LICENSE](LICENSE) for details

## Contributing

Contributions welcome! Please open an issue or submit a pull request.

## Related Packages

- [embedded-swift-utilities](https://github.com/gnorium/embedded-swift-utilities) - Utilities for Embedded Swift
- [web-apis](https://github.com/gnorium/web-apis) - Web API implementations for Swift WebAssembly
- [web-builders](https://github.com/gnorium/web-builders) - HTML, CSS, JS, and SVG DSL builders
- [web-formats](https://github.com/gnorium/web-formats) - Structured data format builders
- [web-types](https://github.com/gnorium/web-types) - Shared web types and design tokens
