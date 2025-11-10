#!/bin/sh
# Replace placeholders in config.json with env vars
CONFIG_FILE=/usr/share/nginx/html/assets/config/config.json

# Create config.json from env if exists
cat <<EOF > $CONFIG_FILE
{
  "REST_API_URL": "${REST_API_URL:-http://localhost:9966/petclinic/api/}"
}
EOF

# Start nginx
exec "$@"
