FROM node:22.21-alpine AS builder
WORKDIR /petclinicapp
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build --omit=dev

FROM nginx:alpine AS final

# Copy built Angular app
COPY --from=builder /petclinicapp/dist/ /usr/share/nginx/html/

# Copy our external Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy entrypoint for dynamic config
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
