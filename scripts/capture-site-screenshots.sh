#!/usr/bin/env bash
set -euo pipefail

SITE_DIR="${1:-public}"
OUT_DIR="${2:-screenshots}"
WIDTH="${SCREENSHOT_WIDTH:-1440}"
HEIGHT="${SCREENSHOT_HEIGHT:-1600}"

if [[ ! -d "$SITE_DIR" ]]; then
  echo "Site directory '$SITE_DIR' does not exist. Run 'hugo --destination $SITE_DIR --cleanDestinationDir' first." >&2
  exit 1
fi
SITE_DIR="$(cd "$SITE_DIR" && pwd)"

find_browser() {
  for candidate in \
    "${CHROME_BIN:-}" \
    google-chrome \
    google-chrome-stable \
    chromium \
    chromium-browser; do
    [[ -z "$candidate" ]] && continue
    if command -v "$candidate" >/dev/null 2>&1; then
      printf '%s\n' "$(command -v "$candidate")"
      return 0
    fi
  done
  return 1
}

BROWSER="$(find_browser || true)"
if [[ -z "$BROWSER" ]]; then
  cat >&2 <<'MSG'
No Chromium-based browser found.

On Ubuntu, the 'chromium-browser' apt package is often only a snap launcher. In
CI/containers, avoid that snap wrapper by installing a real browser binary such
as Google Chrome for Testing or google-chrome-stable, then optionally set:

  CHROME_BIN=/path/to/google-chrome scripts/capture-site-screenshots.sh
MSG
  exit 1
fi

if "$BROWSER" --version 2>&1 | grep -qi 'requires the chromium snap'; then
  cat >&2 <<MSG
'$BROWSER' is the Ubuntu snap launcher, not a usable browser binary here.
Install a snap-free Chromium/Chrome binary and pass it with CHROME_BIN, for example:

  CHROME_BIN=/usr/bin/google-chrome scripts/capture-site-screenshots.sh
MSG
  exit 1
fi

mkdir -p "$OUT_DIR"

capture() {
  local path="$1"
  local name="$2"
  "$BROWSER" \
    --headless=new \
    --no-sandbox \
    --disable-gpu \
    --hide-scrollbars \
    --run-all-compositor-stages-before-draw \
    --virtual-time-budget=5000 \
    --window-size="${WIDTH},${HEIGHT}" \
    --screenshot="${OUT_DIR}/${name}.png" \
    "file://${SITE_DIR%/}/${path}"
}

capture "index.html" "home"
capture "blogi/index.html" "blogi"
capture "cv/index.html" "cv"
capture "blogi/julkaisut/snapchat-tietoturva/index.html" "snapchat-tietoturva"

echo "Screenshots written to ${OUT_DIR}/ using $($BROWSER --version)"
