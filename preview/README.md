# Telivu voice-first screen preview

A single-screen static preview of Telivu's avatar-led voice entry experience. It
uses no health data and makes no API, camera, microphone, storage, or analytics
requests. Voice states and file-selection acknowledgement are UI simulations.

## Design authority

The preview follows Apple interaction conventions while applying the Telivu
Editorial system: ink, graphite, and paper only; editorial/technical typography;
square in-app surfaces; and no gradients, blur, grain, glass, or shadows. The
rounded browser frame is presentation chrome, not an application component.

Run the design validator before publishing:

```bash
preview/scripts/validate-design.sh
```

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
review surface, not the production iOS runtime. The web and native screens share
the same Screen 1 states: ready, listening, processing, response-ready, and
selected image/file evidence.
