#!/usr/bin/env bash
set -euo pipefail

IMAGEID="$1"

# Generate config from the image being tested, including unpublished builds.
docker run --rm --cap-drop ALL --security-opt no-new-privileges "$IMAGEID" --config-example > config.json

sed -i 's/clientSecretEnv/clientSecret/g' config.json

# Start the container with the example config
trap "docker rm -f wallet-gateway-test" EXIT
docker run --name wallet-gateway-test -d -p 3030:3030 \
  --cap-drop ALL --security-opt no-new-privileges \
  -v ./config.json:/app/config.json:ro "$IMAGEID"

# Wait for container to be healthy
timeout 60 bash -c '
  until curl --fail http://localhost:3030/readyz; do
    echo "still not ready"
    sleep "2"
done
'

docker exec wallet-gateway-test node -e '
  if (process.getuid() === 0) {
    throw new Error("Wallet Gateway must run as non-root");
  }
'

echo "Container initialized successfully"
