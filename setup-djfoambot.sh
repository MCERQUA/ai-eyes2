#!/bin/bash
# =============================================================================
# DJ-FoamBot Complete Setup Script
# Run with: sudo bash setup-djfoambot.sh
# =============================================================================

set -e  # Exit on error

DOMAIN="dj-foambot.mikecerqua.ca"
PORT=5001
SERVICE_NAME="dj-foambot"
PROJECT_DIR="/home/mike/Mike-AI/ai-eyes2"
EMAIL="mike@mikecerqua.ca"

echo "=============================================="
echo "  DJ-FoamBot Setup Script"
echo "  Domain: $DOMAIN"
echo "  Port: $PORT"
echo "=============================================="
echo ""

# -----------------------------------------------------------------------------
# Step 1: Check DNS
# -----------------------------------------------------------------------------
echo "[1/5] Checking DNS for $DOMAIN..."
DNS_IP=$(dig +short $DOMAIN 2>/dev/null | head -1)

if [ -z "$DNS_IP" ]; then
    echo "WARNING: DNS not resolved yet for $DOMAIN"
    echo "Make sure you've added the A record:"
    echo "  dj-foambot -> 178.156.162.212"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Exiting. Run again after DNS propagates."
        exit 1
    fi
else
    echo "DNS resolved: $DOMAIN -> $DNS_IP"
fi
echo ""

# -----------------------------------------------------------------------------
# Step 2: Install systemd service
# -----------------------------------------------------------------------------
echo "[2/5] Installing systemd service..."

cat > /etc/systemd/system/$SERVICE_NAME.service << EOF
[Unit]
Description=DJ-FoamBot Voice Server (ai-eyes 2.0)
After=network.target

[Service]
Type=simple
User=mike
WorkingDirectory=$PROJECT_DIR
ExecStart=/usr/bin/python3 $PROJECT_DIR/server.py
Restart=always
RestartSec=10
Environment=PATH=/usr/bin:/usr/local/bin
EnvironmentFile=$PROJECT_DIR/.env

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable $SERVICE_NAME
systemctl start $SERVICE_NAME

echo "Service installed and started."
sleep 2

# Check if service is running
if systemctl is-active --quiet $SERVICE_NAME; then
    echo "Service is running!"
else
    echo "ERROR: Service failed to start. Check logs with:"
    echo "  sudo journalctl -u $SERVICE_NAME -f"
    exit 1
fi
echo ""

# -----------------------------------------------------------------------------
# Step 3: Setup nginx
# -----------------------------------------------------------------------------
echo "[3/5] Setting up nginx..."

cat > /etc/nginx/sites-available/$SERVICE_NAME << EOF
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

        # CORS headers
        add_header 'Access-Control-Allow-Origin' '*' always;
        add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
        add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range' always;
    }
}
EOF

# Enable the site
ln -sf /etc/nginx/sites-available/$SERVICE_NAME /etc/nginx/sites-enabled/

# Test nginx config
echo "Testing nginx configuration..."
nginx -t

if [ $? -ne 0 ]; then
    echo "ERROR: Nginx config test failed!"
    exit 1
fi

systemctl reload nginx
echo "Nginx configured and reloaded."
echo ""

# -----------------------------------------------------------------------------
# Step 4: SSL Certificate
# -----------------------------------------------------------------------------
echo "[4/5] Getting SSL certificate..."

# Check if certbot is installed
if ! command -v certbot &> /dev/null; then
    echo "Installing certbot..."
    apt-get update
    apt-get install -y certbot python3-certbot-nginx
fi

# Get certificate
certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email $EMAIL --redirect

echo "SSL certificate installed."
echo ""

# -----------------------------------------------------------------------------
# Step 5: Verify
# -----------------------------------------------------------------------------
echo "[5/5] Verifying setup..."
echo ""

# Test the endpoint
sleep 2
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://$DOMAIN/api/health 2>/dev/null || echo "000")

if [ "$HTTP_CODE" = "200" ]; then
    echo "SUCCESS! Health check passed."
else
    echo "WARNING: Health check returned HTTP $HTTP_CODE"
    echo "The server might still be starting up. Try:"
    echo "  curl https://$DOMAIN/api/health"
fi

echo ""
echo "=============================================="
echo "  Setup Complete!"
echo "=============================================="
echo ""
echo "DJ-FoamBot is now running at:"
echo "  https://$DOMAIN"
echo ""
echo "Open dj-foambot.html in a browser to test!"
echo ""
echo "Useful commands:"
echo "  sudo systemctl status $SERVICE_NAME    # Check status"
echo "  sudo systemctl restart $SERVICE_NAME   # Restart"
echo "  sudo journalctl -u $SERVICE_NAME -f    # View logs"
echo ""
