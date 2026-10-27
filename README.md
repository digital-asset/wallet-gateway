# wallet-gateway

Docker build for the Wallet Gateway

## How to release

Commits on `main` or on a `release-*` / `release/*` branch create new release artifacts if they don't already exist yet, using the version specified in the `apps/<app>/VERSION` file at the root of the repo

1. Bump the relevant `apps/<app>/VERSION` file
2. Run `bin/bump <app>` to update the lockfile and helm schema
3. Create a PR, have it approved, and merge it into `main` (or push/merge to the release branch for a backport)

## Black Duck container scans

Container images are scanned with Black Duck on build using the shared
[scan action](.github/actions/blackduck-scan/action.yaml). New stable releases use
`ci-release` with the stable version; other builds use `ci-build` with the branch
name. Black Duck versions are recorded as `<app>/<version>` for releases and
`<app>/<branch>` for other builds.

## Nightly source builds

The [nightly workflow](.github/workflows/nightly.yaml) runs daily at 23:23 UTC and can also be dispatched manually. It checks out the latest `main` from
`canton-network/wallet` once, generates the required code, and builds Wallet
Gateway, Splice Portfolio, and their workspace dependencies directly from source.

After the smoke tests and Black Duck scans succeed, it publishes floating tags:

- `ghcr.io/digital-asset/wallet-gateway-unstable/docker/wallet-gateway:nightly`
- `ghcr.io/digital-asset/splice-portfolio-unstable/docker/splice-portfolio:nightly`

Both images use the same upstream commit, recorded in the workflow summary.
To build locally from an upstream checkout:

```shell
docker build --build-context wallet=/path/to/wallet \
  -f apps/Dockerfile.nightly --target wallet-gateway -t wallet-gateway:nightly .
docker build --build-context wallet=/path/to/wallet \
  -f apps/Dockerfile.nightly --target splice-portfolio -t splice-portfolio:nightly .
```

## Testing locally

From the `canton-network/wallet` repo:

1. `pnpm start:canton`
2. `pnpm start:all`
3. `pnpm pm2 stop remote` (to free up port 3030)

From this repo's root:

4. Build the image: `docker build -f ./apps/wallet-gateway/Dockerfile -t wg .`
5. Start the image (requires [host networking enabled](https://docs.docker.com/engine/network/drivers/host/)):

```shell
docker run --init --rm -it --network host \
  --cap-drop ALL --security-opt no-new-privileges \
  -v "$PWD/apps/wallet-gateway/config.test.json:/app/config.json:ro" wg
```
