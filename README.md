# DesignTokens, as used in [gnorium.com](https://gnorium.com)

Universal design tokens for Swift web development based on Apple Human Interface Guidelines.

## Overview

DesignTokens provides CSS custom property definitions and Swift constants for creating consistent, accessible web interfaces. This package implements an Apple HIG-compliant design system, with authentic tokens sourced from `apple.com`, `developer.apple.com`, and `icloud.com`.

## Features

- **Apple HIG Compliant**: Complete implementation of Apple's system colors, fills, and standards.
- **Layered Architecture**: Organized into **Source Tokens** (primitives) and **Applied Tokens** (semantic mappings) for maximum flexibility and consistency.
- **Dark Mode & Contrast Support**: Full support for Light/Dark modes and Less/More contrast variants.
- **CSS Generation**: Integrated functions to generate comprehensive CSS custom property definitions.
- **Type-Safe Swift Constants**: Seamlessly use design tokens in Swift DSL builders with compile-time safety.

## Architecture

The system is built on a two-layer architecture:

### 1. Source Tokens
Authentic primitives derived from Apple's platform environments.
- **System Colors**: 12 polymorphic colors (Red, Orange, Yellow, Green, Mint, Teal, Cyan, Blue, Indigo, Purple, Pink, Brown).
- **Fills & Glyphs**: Platform-specific background fills and iconography (glyph) states.
- **Syntax Colors**: Authentic IDE-grade syntax highlighting palettes.
- **Grays**: Full light/dark mode grayscale ramps.

### 2. Applied Tokens
Semantic tokens that map source primitives to specific UI roles based on Wikimedia Codex.
- **Foregrounds**: `colorBase`, `colorSubtle`, `colorEmphasized`.
- **States**: `colorProgressive`, `colorDestructive`, `colorSuccess`, `colorWarning`.
- **Layout**: `spacing`, `size`, `zIndex`, `borderRadius`.
- **Typography**: `fontFamilyBase`, `fontSizeXXXLarge28`, `lineHeightContent`.

## Installation

### Swift Package Manager

Add DesignTokens to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/gnorium/design-tokens", branch: "main")
]
```

## Usage

### Generating CSS

```swift
import DesignTokens

// Generate Source and Applied tokens for light mode
let sourceCSS = SourceTokensLightModeLessContrastCSS()
let appliedCSS = AppliedTokensLightModeLessContrastCSS()
```

### Using Tokens in Swift

```swift
import DesignTokens
import HTMLBuilder
import CSSBuilder

div {
    "Hello World"
}
.style {
    color(colorBase)
    backgroundColor(backgroundColorProgressive)
    padding(spacing16)
    fontSize(fontSizeMedium16)
}
```

## Requirements

- Swift 6.2+
- Depends on `web-builders` for CSS generation

## License

Apache License 2.0 - See [LICENSE](LICENSE) for details

## Related Packages

- [embedded-swift-utilities](https://github.com/gnorium/embedded-swift-utilities) - Utility functions for Embedded Swift environments
- [markdown-utilities](https://github.com/gnorium/markdown-utilities) - Markdown rendering with media attribution support
- [admin-core](https://github.com/gnorium/admin-core) - Core admin functionalities for web applications
- [web-apis](https://github.com/gnorium/web-apis) - Web API implementations for Swift WebAssembly
- [web-builders](https://github.com/gnorium/web-builders) - HTML, CSS, JS, and SVG DSL builders
- [web-components](https://github.com/gnorium/web-components) - Reusable UI components for web applications
- [web-formats](https://github.com/gnorium/web-formats) - Structured data format builders
- [web-security](https://github.com/gnorium/web-security) - Portable security utilities for web applications
- [web-types](https://github.com/gnorium/web-types) - Shared web types and design tokens
