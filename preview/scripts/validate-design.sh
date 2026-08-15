#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CSS="$ROOT_DIR/styles.css"
HTML="$ROOT_DIR/index.html"
JS="$ROOT_DIR/app.js"

for path in "$CSS" "$HTML" "$JS"; do
  test -f "$path"
done

if rg -n 'radial-gradient|linear-gradient|filter:|box-shadow|blur\(|mix-blend|feTurbulence' "$CSS" "$HTML"; then
  echo "Found a prohibited visual treatment in the web preview." >&2
  exit 1
fi

if test "$(rg -c 'border-radius' "$CSS")" != "1"; then
  echo "Only the presentation frame may use a rounded corner." >&2
  exit 1
fi

rg -q '\.presentation-frame' "$CSS"
rg -q '\.app-surface' "$CSS"
rg -q 'background: var\(--ink\)' "$CSS"
rg -q 'VOICE FIRST · TYPE LESS' "$HTML"
rg -q 'NOT FOR DIAGNOSIS OR EMERGENCIES' "$HTML"
rg -q 'role="status"' "$HTML"
rg -q 'aria-live="polite"' "$HTML"
rg -q 'ready:' "$JS"
rg -q 'listening:' "$JS"
rg -q 'processing:' "$JS"
rg -q 'response-ready' "$JS"
rg -q 'remove-attachment' "$JS"

echo "Telivu web design validation passed."
