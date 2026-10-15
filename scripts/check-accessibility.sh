#!/usr/bin/env bash
set -euo pipefail

# Ajaa pa11y-ci:n (WCAG 2 AA, HTML_CodeSniffer + axe) jokaiselle sivukartan sivulle.
# Käyttää järjestelmän Chromea: aseta CHROME_BIN tai PUPPETEER_EXECUTABLE_PATH.

SITE_DIR="${1:-public}"
PORT="${CHECK_PORT:-8766}"
BASE_URL="http://127.0.0.1:${PORT}"

if [[ ! -f "$SITE_DIR/sitemap.xml" ]]; then
  echo "Tiedostoa '$SITE_DIR/sitemap.xml' ei ole. Rakenna sivusto ensin." >&2
  exit 1
fi

export PUPPETEER_EXECUTABLE_PATH="${PUPPETEER_EXECUTABLE_PATH:-${CHROME_BIN:-$(command -v google-chrome || command -v chromium || true)}}"
if [[ -z "$PUPPETEER_EXECUTABLE_PATH" ]]; then
  echo "Chromea ei löytynyt. Aseta CHROME_BIN." >&2
  exit 1
fi

python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "$SITE_DIR" >/dev/null 2>&1 &
SERVER_PID=$!
trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT

for _ in $(seq 1 50); do
  if python3 -c "import urllib.request, sys; urllib.request.urlopen(sys.argv[1], timeout=1)" "${BASE_URL}/" >/dev/null 2>&1; then
    break
  fi
  sleep 0.1
done

npx --no-install pa11y-ci \
  --config .pa11yci.json \
  --sitemap "${BASE_URL}/sitemap.xml" \
  --sitemap-find "https://topiautio.fi" \
  --sitemap-replace "${BASE_URL}"
