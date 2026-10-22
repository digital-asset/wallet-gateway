FROM node:24 AS build
WORKDIR /app
COPY ./apps/wallet-gateway/package.json ./apps/wallet-gateway/package-lock.json ./
RUN npm ci --omit=dev

FROM europe-docker.pkg.dev/da-images/public/docker/da-base-image:node-1.0.17
WORKDIR /app
COPY --from=build --chown=nonroot:nonroot /app/node_modules ./node_modules
ENTRYPOINT ["./node_modules/.bin/wallet-gateway-remote"]
