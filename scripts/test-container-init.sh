#!/usr/bin/env bash
set -euo pipefail

VERSION="$1"
IMAGE="$2"

# Generate a default config file for the current version
npx --yes @canton-network/wallet-gateway-remote@$VERSION --config-example > config.json

# Start the container with the example config
docker run -p 3030:3030 -v ./config.json:/app/config.json $IMAGE &

# Wait for container to be healthy
curl --retry 10 --retry-max-time 30 http://localhost:3030/readyz

echo "Container initialized successfully"
