FROM node:24 AS builder
WORKDIR /app
COPY ./apps/splice-portfolio/package.json ./apps/splice-portfolio/package-lock.json ./
RUN npm ci --omit=dev --ignore-scripts

FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/node_modules/@canton-network/example-portfolio/dist /usr/share/nginx/html/

# Runtime portfolio config is served from /config.json.
# To override it, mount a file at /usr/share/nginx/html/config.json.

COPY apps/splice-portfolio/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
