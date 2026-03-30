# wallet-gateway

Docker build for the Wallet Gateway

## How to release

Commits on `main` create new release artifacts if they don't already exist yet using the version specified in the `apps/<app>/VERSION` file at the root of the repo

1. Bump the relevant `apps/<app>/VERSION` file
2. (Wallet Gateway): Run `bump-wallet-gateway` to update the lockfile and helm schema
3. Create a PR, have it approved, and merge it into `main`
