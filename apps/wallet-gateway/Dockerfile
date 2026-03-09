FROM node:24.14-alpine3.22
ARG version=REQUIRED
USER node:node
WORKDIR /app
RUN npm install @canton-network/wallet-gateway-remote@${version}
ENTRYPOINT ["./node_modules/.bin/wallet-gateway-remote"]
