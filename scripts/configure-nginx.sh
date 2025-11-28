#!/bin/bash
# Configure NGINX with multiple server blocks

set -e

DOCKER_SUBDOMAIN=$1
INSTANCE_SUBDOMAIN=$2

if [ -z "$DOCKER_SUBDOMAIN" ] || [ -z "$INSTANCE_SUBDOMAIN" ]; then
    echo "Usage: $0 <docker_subdomain> <instance_subdomain>"
    echo "Example: $0 ec2-docker1.example.com ec2-instance1.example.com"
    exit 1
fi

echo "Configuring NGINX for:"
echo "  - Docker subdomain: $DOCKER_SUBDOMAIN"
echo "  - Instance subdomain: $INSTANCE_SUBDOMAIN"

# Install NGINX and Certbot
sudo dnf install -y nginx certbot python3-certbot-nginx

# Create NGINX configuration
sudo tee /etc/nginx/conf.d/app.conf > /dev/null <<EOF
# Configuration for instance subdomain - serves static text
server {
    listen 80;
    server_name $INSTANCE_SUBDOMAIN;

    location / {
        return 200 'Hello from Instance\n';
        add_header Content-Type text/plain;
    }

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
}

# Configuration for Docker subdomain - proxies to Docker container
server {
    listen 80;
    server_name $DOCKER_SUBDOMAIN;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        # Timeout settings
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
}
EOF

# Test NGINX configuration
sudo nginx -t

# Start and enable NGINX
sudo systemctl start nginx
sudo systemctl enable nginx

echo "NGINX configured successfully!"
echo ""
echo "To enable HTTPS with Let's Encrypt (after DNS is configured):"
echo "  sudo certbot --nginx -d $DOCKER_SUBDOMAIN -d $INSTANCE_SUBDOMAIN"
