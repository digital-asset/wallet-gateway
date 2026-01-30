FROM node:alpine AS builder
WORKDIR /app
ARG version=REQUIRED
RUN npm install "@canton-network/example-portfolio@${version}"



FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/node_modules/@canton-network/example-portfolio/dist /usr/share/nginx/html/

# Configure nginx for SPA routing
RUN echo 'server { \
    listen 80; \
    server_name localhost; \
    root /usr/share/nginx/html; \
    index index.html; \
    location / { \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
