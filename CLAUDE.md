# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A multi-platform SwiftUI app targeting iOS, iPadOS, macOS, and visionOS. Currently a minimal starter project with no external dependencies.

- **Language:** Swift 5.0
- **UI Framework:** SwiftUI
- **Bundle ID:** math.Math-App
- **Deployment Targets:** iOS 26.4, macOS 26.3, visionOS 26.4

## Build Commands

```bash
# Open in Xcode
open "Math App.xcodeproj"

# Build from command line
xcodebuild -project "Math App.xcodeproj" -scheme "Math App" -configuration Debug build

# Build for release
xcodebuild -project "Math App.xcodeproj" -scheme "Math App" -configuration Release build
```

No test targets, linting, or formatting tools are currently configured.

## Architecture

- **Entry point:** `Math App/Math_AppApp.swift` — standard SwiftUI `@main` App with a single `WindowGroup`
- **Root view:** `Math App/ContentView.swift`
- **Assets:** `Math App/Assets.xcassets/`

The project uses Xcode's file-system-synchronized groups (no manual file references needed in pbxproj).

## Build Settings of Note

- Default actor isolation: MainActor
- Approachable Concurrency: enabled (Swift async/await ready)
- App Sandbox: enabled (macOS), User File Access: read-only
- String Catalogs: enabled for localization
