# wallet-gateway

Docker build for the Wallet Gateway

## Updating npm

To update/reinstall the latest `wallet-gateway-remote` from NPM into the local nix environment:

1. `cd ./nix`
2. `node2nix --strip-optional-dependencies -i ./node-packages.json -c npmpkgs.nix`
