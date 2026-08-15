# Telivu Screen 1 — Design System Correction Plan

**Document type:** Implementation plan and task list
**Scope:** Screen 1 only — voice-first health companion with image and file input
**Platforms:** Native iPhone app and matching web preview
**Status:** Ready for execution
**Product language:** English first

---

## 1. Outcome

Deliver one production-faithful Telivu home screen that:

- feels visually related to the approved monochrome editorial reference;
- behaves like a native iOS application;
- lets the user start voice input, add an image, or add a file without typing;
- presents the same composition and states in SwiftUI and the web preview;
- follows one documented, testable design system instead of relying on visual imitation.

This plan does not build the medical assistant backend or connect OpenAI APIs. It prepares every visible state and interface boundary required for that integration.

---

## 2. Locked design decision

Telivu will use a two-layer system:

1. **Apple Human Interface Guidelines and native SwiftUI** for behaviour, accessibility, navigation, permissions, input, safe areas, and touch interaction.
2. **Telivu Editorial Design System** for colour, typography, spacing, borders, illustrations, hierarchy, and brand expression.

The supplied Saturn HTML is an art-direction reference, not a reusable component library. Do not add a third-party SwiftUI design system or a shadcn-style compatibility layer.

### Source precedence

When sources disagree, implement in this order:

1. This correction plan for Screen 1 scope and delivery gates.
2. `TELIVU-USER-FLOW-AND-UI-SPEC.md` for Telivu interaction and UI rules.
3. `Monochrome_Editorial_App_Design_Guidelines.docx` for visual tokens and restrictions.
4. Apple Human Interface Guidelines for native behaviour and accessibility.
5. `saturn-pisces-card.html` for editorial rhythm, density, and illustration character.

### Conflict decision

- A rounded device shell may appear around the **web presentation preview** only.
- Everything inside the app surface uses square corners, flat fills, and no elevation.
- Global grain, gradients, blur, translucency, glass, and shadows are prohibited.
- Pencil texture is limited to approved explanatory illustration assets.
- Astrology diagrams, labels, symbols, and the butterfly must not appear in Telivu.

---

## 3. Screen 1 contract

### Required content order

1. Safe-area-aware header with `TELIVU` and language control.
2. New, private-conversation metadata.
3. Ink-black companion illustration panel.
4. Technical context label such as `VOICE FIRST · TYPE LESS`.
5. Editorial prompt: `Tell me what’s going on.` and supporting instruction explaining that the user can speak, add an image, or add a file.
6. Persistent primary voice action.
7. Secondary `ADD IMAGE` and `ADD FILE` actions.
8. Visible live status or transcript region.
9. Safety copy: `NOT FOR DIAGNOSIS OR EMERGENCIES.`

### Required states

| State | Visible requirement | Available actions |
|---|---|---|
| Ready | Companion is ready; microphone is inactive | Speak, add image, add file, change language |
| Listening | Explicit listening label, animated waveform, visible `STOP` | Stop, add image, add file |
| Processing | Final transcript remains visible; calm progress label | Stop/cancel if active, retain attachments |
| Response-ready | Short visual response placeholder and playback affordance | Play/pause, speak again, add evidence |
| Image selected | Thumbnail or filename plus remove/replace control | Speak, remove, replace, continue |
| File selected | Filename and file type plus remove/replace control | Speak, remove, replace, continue |
| Permission denied | Plain explanation with system Settings recovery action | Open Settings, use image/file instead |
| Input error | Specific error without losing existing evidence | Retry, choose another input |

Audio must never be the only indication of state. The entire flow must remain understandable with sound off.

---

## 4. Locked design tokens

### Colour

| Token | Value | Use |
|---|---:|---|
| `ink` | `#000000` | Primary text, dark panel, primary controls |
| `graphite` | `#5E5E5E` | Secondary text, dividers, illustration strokes |
| `paper` | `#F7F7F7` | App background and inverse text |

Alpha variations may derive only from these colours. User-selected photographs and document previews retain their source colours.

### Typography

| Role | Preferred implementation | Use |
|---|---|---|
| Editorial | Bodoni 72, falling back to Didot | Prompt, explanations, response copy |
| Technical | Monaco, falling back to Menlo | Labels, status, controls, metadata |

Do not silently replace the editorial hierarchy with San Francisco. All text styles must scale with Dynamic Type.

### Geometry and spacing

- Base layout width: 360 pt.
- Content inset: 20 pt.
- Allowed spacing scale: 4, 8, 12, 16, 20, 24, 28, 32, 40, 48 pt.
- Product corner radius: 0.
- Divider/border width: 1 pt by default.
- Minimum interactive target: 44 × 44 pt.
- Use spacing and dividers instead of nested cards.

---

## 5. Execution phases

### Phase 0 — Freeze the contract

**Goal:** Prevent more visual drift before implementation.

- [x] **DS-001** Approve the two-layer design decision: Apple HIG plus Telivu Editorial.
- [x] **DS-002** Confirm that Screen 1 is the only implementation scope.
- [x] **DS-003** Record the source precedence in the web and iOS READMEs.
- [ ] **DS-004** Capture baseline screenshots of the current public preview and SwiftUI preview.
- [ ] **DS-005** Mark conflicting older Screen 1 instructions as superseded; do not delete historical documents.

**Exit gate:** One agreed screen contract, one content order, and one state list.

### Phase 1 — Encode the Telivu Editorial system

**Goal:** Turn the visual rules into reusable tokens and primitives.

- [ ] **DS-101** Split SwiftUI tokens into colour, typography, spacing, stroke, layout, and motion definitions.
- [x] **DS-102** Mirror the same semantic token names as CSS custom properties in the web preview.
- [x] **DS-103** Define named type styles instead of using one-off font sizes in views.
- [x] **DS-104** Define one flat press style with ready, pressed, disabled, and focus states.
- [ ] **DS-105** Define deterministic illustration asset rules and fixed non-zero seeds.
- [x] **DS-106** Add automated token checks for prohibited colours, radii, gradients, blur, material, and shadows.

**Files:**

- `ios/Telivu/Telivu/DesignSystem/`
- `ios/Telivu/scripts/validate-ui.sh`
- `preview/styles.css`
- new `preview/scripts/validate-design.sh`

**Exit gate:** Web and iOS use the same named tokens; prohibited visual treatments fail validation.

### Phase 2 — Specify and build Screen 1 components

**Goal:** Build a small native component set designed for this screen.

- [x] **DS-201** Build `TLHeader` with wordmark and native language menu.
- [x] **DS-202** Build `TLEditorialIntro` with kicker, title, and supporting copy.
- [x] **DS-203** Build `TLCompanionPanel` using ink background and deterministic monochrome art.
- [x] **DS-204** Build `TLVoiceControl` with Ready, Listening, Processing, and Response-ready states.
- [x] **DS-205** Build `TLAttachmentAction` for image and file entry points.
- [x] **DS-206** Build `TLAttachmentSummary` for selected evidence and remove/replace actions.
- [x] **DS-207** Build `TLStatusRegion` for captions, transcript, errors, and permission recovery.
- [x] **DS-208** Build `TLSafetyNote` with the locked safety copy.
- [x] **DS-209** Assemble the components into one responsive Screen 1 composition.

**Exit gate:** All required states can be demonstrated locally without a backend.

### Phase 3 — Correct the web preview

**Goal:** Make the public preview an accurate representation of the native design.

- [x] **WEB-301** Remove global grain from the app surface.
- [x] **WEB-302** Remove inner rounded corners, gradients, and shadows.
- [x] **WEB-303** Change the companion panel from graphite to ink.
- [x] **WEB-304** Retain a rounded outer device frame only as clearly separate presentation chrome.
- [x] **WEB-305** Reorder content to match the locked Screen 1 contract.
- [x] **WEB-306** Implement every required state through deterministic demo controls.
- [x] **WEB-307** Ensure image/file controls use actual browser pickers and expose selected state.
- [x] **WEB-308** Add keyboard focus, accessible labels, live-region announcements, and reduced-motion handling.

**Files:**

- `preview/index.html`
- `preview/styles.css`
- `preview/app.js`
- `preview/_headers`

**Exit gate:** The preview passes the design validator, keyboard test, and Screen 1 state test.

### Phase 4 — Align native SwiftUI

**Goal:** Make the iOS screen the authoritative product implementation.

- [x] **IOS-401** Replace the older dashboard composition with the locked content hierarchy.
- [x] **IOS-402** Use `safeAreaInset` for the persistent voice/action region.
- [x] **IOS-403** Retain native `PhotosPicker` and `fileImporter` entry points.
- [x] **IOS-404** Add visible attachment selection, removal, and replacement states.
- [ ] **IOS-405** Add microphone permission, denial, interruption, and retry states.
- [x] **IOS-406** Respect `accessibilityReduceMotion` and stop decorative motion when requested.
- [x] **IOS-407** Verify every custom control has a native `Button`, role, label, value, and 44 pt target.
- [ ] **IOS-408** Verify Dynamic Type through the largest accessibility size without clipped status or safety text.
- [ ] **IOS-409** Prepare explicit interfaces for OpenAI Realtime/audio, transcription, and attachment analysis without embedding API logic in view components.

**Files:**

- `ios/Telivu/Telivu/Screens/TelivuHomeView.swift`
- `ios/Telivu/Telivu/Components/`
- `ios/Telivu/Telivu/Models/TelivuHomeModel.swift`
- `ios/Telivu/Telivu/DesignSystem/`

**Exit gate:** Native Screen 1 matches the web composition and all eight required states are inspectable.

### Phase 5 — Accessibility and visual verification

**Goal:** Replace subjective approval with repeatable evidence.

- [ ] **QA-501** Compare web and iOS screenshots at the same 390 × 844 viewport.
- [ ] **QA-502** Test compact-height and large-screen layouts.
- [ ] **QA-503** Test Dynamic Type at default, XXXL, and Accessibility 3 or larger.
- [ ] **QA-504** Test VoiceOver reading order, labels, values, and live announcements.
- [x] **QA-505** Test keyboard-only operation of the web preview.
- [x] **QA-506** Test Reduced Motion and sound-off comprehension.
- [x] **QA-507** Verify every control target is at least 44 × 44 pt.
- [ ] **QA-508** Verify contrast and that state is never conveyed by colour alone.
- [x] **QA-509** Run prohibited-style and palette scans against both implementations.
- [x] **QA-510** Review the final screen against the supplied reference for hierarchy and editorial character—not literal astrology geometry.

**Exit gate:** No known critical accessibility, interaction, token, or cross-platform parity failures.

### Phase 6 — Publish and hand off

**Goal:** Publish only the reviewed build and leave inspectable evidence.

- [ ] **REL-601** Record before/after screenshots and validation results.
- [ ] **REL-602** Commit only reviewed Screen 1 design-system files to the existing GitHub branch.
- [ ] **REL-603** Deploy the matching static preview to the existing Cloudflare Pages project.
- [ ] **REL-604** Verify the canonical Pages URL returns the reviewed version.
- [ ] **REL-605** Verify Ready, Listening, image selection, file selection, and error recovery on the live URL.
- [ ] **REL-606** Update the handoff README with the commit, live URL, scope, and known limitations.

**Exit gate:** GitHub and Cloudflare expose the same reviewed Screen 1 implementation.

---

## 6. Acceptance checklist

The screen is complete only when all items pass:

### Visual system

- [ ] Only ink, graphite, paper, and derived alpha variants appear in product UI.
- [ ] The in-app companion panel is ink black, not graphite.
- [ ] No in-app product surface has rounded corners.
- [ ] No global grain, gradient, blur, glass, translucency, elevation, or shadow remains.
- [ ] Pencil texture appears only in approved explanatory illustration assets.
- [ ] Editorial and technical typography roles are visibly distinct.
- [ ] Layout uses the locked spacing scale and aligned 20 pt content margins.

### Interaction

- [ ] Voice input starts only after an explicit tap.
- [ ] Listening has a persistent visible label and `STOP` action.
- [ ] The transcript/status remains visible and never depends on audio alone.
- [ ] Add image and Add file are real controls, not decorative buttons.
- [ ] Selected attachments can be reviewed, removed, or replaced.
- [ ] Errors preserve previously selected evidence.
- [ ] Safety copy remains visible in every voice state.

### Native quality

- [ ] SwiftUI uses native semantic controls and system input pickers.
- [ ] All controls expose accessibility labels and values.
- [ ] All targets are at least 44 × 44 pt.
- [ ] Dynamic Type and VoiceOver do not hide core actions.
- [ ] Reduced Motion removes continuous decorative animation.
- [ ] The app remains understandable with sound disabled.

### Delivery parity

- [ ] Web and iOS show the same hierarchy, copy, tokens, and state meanings.
- [ ] Automated checks pass before deployment.
- [ ] The live Cloudflare build is verified after deployment.
- [ ] The GitHub commit corresponds to the verified live build.

---

## 7. Recommended execution order

```text
Contract freeze
    → shared tokens and validators
    → Screen 1 components
    → web correction
    → SwiftUI alignment
    → accessibility and visual verification
    → GitHub and Cloudflare publication
```

Do not begin OpenAI API integration until Phase 2 has locked the state interfaces. API work may proceed after that boundary without changing the visual system.

---

## 8. Definition of done

Screen 1 is done when a reviewer can open the public preview and the native build, recognize the same Telivu screen, complete voice/image/file entry without typing, understand every state without sound, and verify through automated checks that the implementation follows Apple interaction conventions plus the Telivu Editorial visual rules.
