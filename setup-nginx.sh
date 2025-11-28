#!/bin/bash
# Setup nginx for ai-guy.mikecerqua.ca

cat << 'NGINX' | sudo tee /etc/nginx/sites-available/ai-guy.mikecerqua.ca
server {
    listen 80;
    server_name ai-guy.mikecerqua.ca;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
NGINX

sudo ln -sf /etc/nginx/sites-available/ai-guy.mikecerqua.ca /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
sudo certbot --nginx -d ai-guy.mikecerqua.ca --non-interactive --agree-tos -m mikecerqua@gmail.com
