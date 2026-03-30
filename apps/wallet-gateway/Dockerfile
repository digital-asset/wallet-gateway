FROM node:24.14-alpine3.22
USER node:node
WORKDIR /app

COPY --chown=node:node ./apps/wallet-gateway/package.json ./apps/wallet-gateway/package-lock.json ./
RUN npm ci --omit=dev
ENTRYPOINT ["./node_modules/.bin/wallet-gateway-remote"]
