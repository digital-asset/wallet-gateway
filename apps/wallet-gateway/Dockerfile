FROM europe-docker.pkg.dev/da-images/public/docker/da-base-image:node-1.0.17 AS node

FROM node AS build
WORKDIR /app
COPY ./apps/wallet-gateway/package.json ./apps/wallet-gateway/package-lock.json ./
RUN npm ci --omit=dev

FROM node
WORKDIR /app
COPY --from=build --chown=nonroot:nonroot /app/node_modules ./node_modules
ENTRYPOINT ["./node_modules/.bin/wallet-gateway-remote"]
