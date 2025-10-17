FROM cgr.dev/chainguard/node
ARG version=REQUIRED
RUN npm install @canton-network/wallet-gateway-remote@${version}
ENTRYPOINT ["./node_modules/.bin/wallet-gateway-remote", "-c", "./config.json"]
