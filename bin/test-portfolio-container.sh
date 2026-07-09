#!/usr/bin/env bash
set -euo pipefail

IMAGEID="$1"

PORT="${PORT:-8082}"
PLAYWRIGHT_VERSION="1.61.1"
PLAYWRIGHT_IMAGE="mcr.microsoft.com/playwright:v${PLAYWRIGHT_VERSION}-noble"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Start the container
trap "docker rm -f splice-portfolio-test" EXIT
docker run --name splice-portfolio-test -d -p $PORT:80 "$IMAGEID"

# Wait for nginx to serve the app
timeout 60 bash -c "
  until curl --fail --silent --output /dev/null http://localhost:$PORT/; do
    echo 'still not ready'
    sleep 2
  done
"

# SPA fallback must serve the connect route with a 200
status=$(curl --silent --output /dev/null --write-out '%{http_code}' "http://localhost:$PORT/next/connect")
if [[ "$status" != "200" ]]; then
  echo "Expected 200 from /next/connect, got $status" >&2
  exit 1
fi
echo "/next/connect returned 200"

# Runtime config must be served
curl --fail --silent --output /dev/null "http://localhost:$PORT/config.json"
echo "/config.json returned 200"

# Verify the rendered page shows the header and connect button.
# The page is a client-side rendered SPA, so we need a real browser.
# Browsers are baked into the image; npm i only fetches the JS package.
docker run --rm --network host \
  -v "$SCRIPT_DIR/test-portfolio-container.check.js:/tmp/check.js:ro" \
  -e "PORT=$PORT" \
  "$PLAYWRIGHT_IMAGE" \
  bash -c "cd /tmp && npm install --silent --no-fund --no-audit playwright@${PLAYWRIGHT_VERSION} && node check.js"

echo "Portfolio container test passed"
