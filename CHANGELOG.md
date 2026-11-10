# Changelog

All notable changes to this project are documented in this file.

## [2.0] - 2026-11-10

Updated by Russell Collis.

### Added
- App icon
- Line numbers in the editor gutter
- Toolbar buttons for headings 1–6, task lists, and horizontal rules
- SF Symbols icons and tooltips for the formatting toolbar buttons
- Bundled pandoc binary
- Vendored GCDWebServer as a local Swift package
- README and CHANGELOG

### Changed
- "Automatically reload page" is now on by default
- The editor starts with a blank document instead of the sample text
- The editor/preview divider is centred when the window opens
- Dependencies moved to Swift Package Manager
- Updated to current AppAuth APIs (`OIDExternalUserAgentSession`)
- Version bumped to 2.0 (build 2); copyright notice credits the update

### Fixed
- Toolbar button images and heading tags lost when macOS rebuilds toolbar items
- Removed the empty `CFBundleIconFile` entry from `Info.plist` so the asset-catalog icon is used

## [1.0] - 2018-04-24

Initial release by Satoshi Iwaki.

- Markdown editor with live HTML preview
- GitHub Flavored Markdown, Markdown, PHP Markdown Extra, and Strict Markdown converters
- Upload to GitHub Gists
