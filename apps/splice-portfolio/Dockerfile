FROM europe-docker.pkg.dev/da-images/public/docker/da-base-image:node-1.0.17 AS node
FROM nginx:1.31.8-alpine-slim AS nginx

FROM node AS build
WORKDIR /app
COPY ./apps/splice-portfolio/package.json ./apps/splice-portfolio/package-lock.json ./
RUN npm ci --omit=dev --ignore-scripts

FROM nginx

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /app/node_modules/@canton-network/example-portfolio/dist /usr/share/nginx/html/

# Runtime portfolio config is served from /config.json.
# To override it, mount a file at /usr/share/nginx/html/config.json.

COPY apps/splice-portfolio/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
