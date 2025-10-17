FROM cgr.dev/chainguard/node
RUN npm install @canton-network/wallet-gateway-remote
ENTRYPOINT ["./node_modules/.bin/wallet-gateway-remote", "-c", "./config.json"]
