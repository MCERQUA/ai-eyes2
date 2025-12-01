#!/bin/bash
# Setup nginx for DJ-FoamBot (ai-eyes 2.0)
# Run with: sudo bash setup-nginx-djfoambot.sh

DOMAIN="dj-foambot.mikecerqua.ca"
PORT=5001

echo "Setting up nginx for $DOMAIN -> localhost:$PORT"

# Create nginx config
cat > /etc/nginx/sites-available/dj-foambot << EOF
server {
    listen 80;
    server_name $DOMAIN;

    location / {
        proxy_pass http://127.0.0.1:$PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
        proxy_read_timeout 86400;
    }
}
EOF

# Enable the site
ln -sf /etc/nginx/sites-available/dj-foambot /etc/nginx/sites-enabled/

# Test nginx config
nginx -t

if [ $? -eq 0 ]; then
    echo "Nginx config OK, reloading..."
    systemctl reload nginx

    echo ""
    echo "Getting SSL certificate with Let's Encrypt..."
    certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email mike@yourdomain.com --redirect

    echo ""
    echo "Done! DJ-FoamBot should be available at https://$DOMAIN"
else
    echo "Nginx config error! Please check the configuration."
    exit 1
fi
