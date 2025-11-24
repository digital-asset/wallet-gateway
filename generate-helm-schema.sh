#! /usr/bin/env bash
set -euo pipefail

schema=$(npx --yes @canton-network/wallet-gateway-remote@$(cat VERSION) --config-schema)
base=$(cat ./values.schema.base.json)

echo "$base $schema" | jq -n 'reduce inputs as $item ({}; . * $item)'
