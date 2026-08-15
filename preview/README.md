# Telivu voice-first screen preview

A single-screen static preview of Telivu's avatar-led voice entry experience. It
uses no health data and makes no API, camera, microphone, storage, or analytics
requests. The listening state and file-selection acknowledgement are UI
simulations.

## Run locally

```bash
python3 -m http.server 4173 --directory preview
```

Open `http://127.0.0.1:4173`.

## Cloudflare Pages

Deploy the directory directly:

```bash
wrangler pages project create telivu-preview
wrangler pages deploy preview --project-name telivu-preview --branch main
```

The native SwiftUI application remains under `ios/Telivu`. This preview is a
review surface, not the production iOS runtime.
