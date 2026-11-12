# Markdown Editor for macOS

[![Buy me a coffee](https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20coffee&emoji=&slug=russcollis&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff)](https://www.buymeacoffee.com/russcollis)

A native macOS Markdown editor written in Objective-C, with a live side-by-side HTML preview.

Originally created by [Satoshi Iwaki](https://github.com/satoshi-iwaki) (2018).
Updated by **Russell Collis** (2026).

## Features

- Split-view editor and live preview, with the divider centred on launch
- Preview auto-reloads as you type (on by default; toggle with **Automatically reload page**)
- Multiple Markdown flavours, rendered with the bundled [pandoc](https://pandoc.org):
  - GitHub Flavored Markdown
  - Markdown
  - PHP Markdown Extra
  - Strict Markdown
- Line numbers in the editor gutter
- Formatting toolbar: bold, italic, strikethrough, quote, code, link, headings 1–6,
  bulleted / numbered / task lists, and horizontal rules
- Upload documents to GitHub Gists (OAuth sign-in via AppAuth)

## Requirements

- macOS 12.0 or later
- Xcode with Swift Package Manager support

## Building

1. Clone the repository:
   ```sh
   git clone https://github.com/RussCollis/markdown-editor-mac-objc.git
   ```
2. Open `MarkdownEditor/MarkdownEditor.xcodeproj` in Xcode.
3. Xcode resolves the package dependencies automatically.
4. Select the **MarkdownEditor** scheme and run (⌘R).

## Dependencies

| Package | Purpose |
| --- | --- |
| [AppAuth](https://github.com/openid/AppAuth-iOS) | GitHub OAuth sign-in for Gists |
| [GCDWebServer](https://github.com/swisspol/GCDWebServer) (vendored in `MarkdownEditor/Packages`) | Local web server that serves the preview |
| [pandoc](https://pandoc.org) (bundled in `MarkdownEditor/MarkdownEditor/Binaries`) | Markdown to HTML conversion |

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## License

MIT. See [LICENSE](LICENSE).
