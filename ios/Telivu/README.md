# Telivu iOS UI

Native SwiftUI implementation of the single voice-first Telivu home screen.

## Current milestone

- one screen only: conversation entry;
- exact ink `#000000`, graphite `#5E5E5E`, and paper `#F7F7F7` palette;
- Bodoni 72 / Monaco rendered-reference font pair with explicit fallbacks;
- reusable native components for the top bar, session metadata, avatar stage,
  attachment controls, voice control, status, and selected-evidence summary;
- ready, listening, processing, and response-ready states with Reduce Motion support;
- native `PhotosPicker` and `fileImporter` entry points;
- persistent voice actions using `safeAreaInset` and a Dynamic Type-safe scroll layout.

The microphone state is a UI prototype. Audio capture, transcription, OpenAI APIs,
uploads, persistence, and medical responses are deliberately not connected yet.

## Generate the Xcode project

The checked-in `project.yml` is the project definition. On a Mac with full Xcode:

```bash
brew install xcodegen
cd ios/Telivu
xcodegen generate
open Telivu.xcodeproj
```

Select an iPhone simulator running iOS 17 or later, then run the `Telivu` scheme.

Run the repository-safe structural validation at any time:

```bash
ios/Telivu/scripts/validate-ui.sh
```

The structural validation parses every Swift file and checks the locked visual rules.
Full simulator validation still requires a selected full Xcode installation.

## Design authority

Apple Human Interface Guidelines govern native behaviour, accessibility, safe
areas, and system pickers. The Telivu Editorial system governs the visual layer:
ink, graphite, paper, Bodoni/Monaco roles, square in-app surfaces, thin dividers,
and deterministic monochrome companion art. No third-party UI library is used.

## Font decision

The supplied HTML resolves to Bodoni 72 and Monaco on its authoring Mac because
Romana and Consolas are not installed. This implementation reproduces that pair:

- editorial: Bodoni 72, explicit fallback to Didot;
- technical: Monaco, explicit fallback to Menlo.

Before distributing the app, verify the chosen font licences and availability on the
target iOS build. If licensed Romana and Consolas files are supplied, add them to the
target and update `TelivuFont` without changing the type sizes or roles.
