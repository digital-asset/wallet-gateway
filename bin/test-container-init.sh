#!/usr/bin/env bash
set -euo pipefail

VERSION="$1"
IMAGEID="$2"

# Generate a default config file for the current version
npx --yes @canton-network/wallet-gateway-remote@$VERSION --config-example > config.json

# Start the container with the example config
trap "docker rm -f wallet-gateway-test" EXIT
docker run --name wallet-gateway-test -p 3030:3030 -v ./config.json:/app/config.json $IMAGEID &

# Wait for container to be healthy
timeout 60 bash -c '
  until curl --fail http://localhost:3030/readyz; do
    echo "still not ready"
    sleep "2"
done
'

echo "Container initialized successfully"
