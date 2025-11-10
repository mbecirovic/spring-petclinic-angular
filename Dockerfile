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

# Fix permissions
RUN chmod a+rwx /var/cache/nginx /var/run /var/log/nginx

# Copy entrypoint for dynamic config
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Fix permissions before switching user
RUN mkdir -p /usr/share/nginx/html/assets/config && \
    chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

EXPOSE 8080
USER nginx

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
