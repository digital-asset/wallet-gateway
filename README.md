# wallet-gateway

Docker build for the Wallet Gateway

## How to release

Commits on `main` create new release artifacts if they don't already exist yet using the version specified in the `VERSION` file at the root of the repo

1. Regenerate the values schema if needed:

```
helm-get {chart name}
```

**NOTE:** In the case of `wallet-gateway`, most of its schema is derived from internal configuration. So even if there are no values changes in this repo you most likely will still need to regenerate the values schema.

2. Bump the `VERSION` file at the root of the repo
3. Create a PR, have it approved, and merge it into `main`
