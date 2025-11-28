#!/bin/bash
set -e

# Update system
dnf update -y

# Install packages
dnf install -y docker nginx certbot python3-certbot-nginx amazon-cloudwatch-agent

# Start Docker
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Run Docker container
docker run -d \
  --name namaste-container \
  --restart always \
  -p 8080:8080 \
  nginx:alpine sh -c 'echo "server { listen 8080; location / { return 200 \"Namaste from Container\\n\"; add_header Content-Type text/plain; } }" > /etc/nginx/conf.d/default.conf && nginx -g "daemon off;"'

# Configure NGINX
cat > /etc/nginx/conf.d/default.conf <<'EOF'
server {
    listen 80;
    server_name ${instance_subdomain};
    location / {
        return 200 'Hello from Instance\n';
        add_header Content-Type text/plain;
    }
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
}

server {
    listen 80;
    server_name ${docker_subdomain};
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
}
EOF

nginx -t
systemctl start nginx
systemctl enable nginx

# Configure CloudWatch Agent
cat > /opt/aws/amazon-cloudwatch-agent/etc/config.json <<'EOF'
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/nginx/access.log",
            "log_group_name": "${cloudwatch_log_group}",
            "log_stream_name": "{instance_id}/nginx-access",
            "retention_in_days": 7
          },
          {
            "file_path": "/var/log/nginx/error.log",
            "log_group_name": "${cloudwatch_log_group}",
            "log_stream_name": "{instance_id}/nginx-error",
            "retention_in_days": 7
          }
        ]
      }
    }
  },
  "metrics": {
    "namespace": "CWAgent",
    "metrics_collected": {
      "mem": {
        "measurement": [
          {
            "name": "mem_used_percent",
            "rename": "MemoryUtilization",
            "unit": "Percent"
          }
        ],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": [
          {
            "name": "used_percent",
            "rename": "DiskUtilization",
            "unit": "Percent"
          }
        ],
        "metrics_collection_interval": 60,
        "resources": ["*"]
      },
      "cpu": {
        "measurement": [
          {
            "name": "cpu_usage_active",
            "rename": "CPUUtilization",
            "unit": "Percent"
          }
        ],
        "metrics_collection_interval": 60,
        "totalcpu": true
      }
    }
  }
}
EOF


# Start CloudWatch Agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -s \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/config.json

echo "Setup completed!"
