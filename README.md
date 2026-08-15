# Telivu

Telivu is an English-first, voice-first health companion for everyday Indians.
This repository currently contains the first interface milestone: a single
avatar-led conversation screen with image and file entry points.

## Preview

**Live web preview:** https://telivu-preview.pages.dev/

The web preview is a visual interaction prototype. It does not activate the
microphone, upload files, call OpenAI, store health data, or provide medical
advice.

## Native iOS

The native SwiftUI implementation is under `ios/Telivu`. It uses a small
Telivu-owned component system rather than a third-party Tailwind-style library.

Generate the Xcode project on a Mac with full Xcode:

```bash
brew install xcodegen
cd ios/Telivu
xcodegen generate
open Telivu.xcodeproj
```

Run the structural validation:

```bash
ios/Telivu/scripts/validate-ui.sh
```

## Current boundary

- English first
- Voice-first and visual-first
- Image and PDF picker entry points
- Monochrome editorial design system
- UI states only; OpenAI voice and medical-response APIs are not connected yet
