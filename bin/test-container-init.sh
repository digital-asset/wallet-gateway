#!/usr/bin/env bash
set -euo pipefail

IMAGEID="$1"

# Generate config from the image being tested, including unpublished builds.
docker run --rm "$IMAGEID" --config-example > config.json

sed -i 's/clientSecretEnv/clientSecret/g' config.json

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
