#!/bin/bash
# Install and configure CloudWatch Agent

set -e

echo "Installing CloudWatch Agent..."

# Download CloudWatch Agent
wget https://amazoncloudwatch-agent.s3.amazonaws.com/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm

# Install the agent
sudo rpm -U ./amazon-cloudwatch-agent.rpm

# Clean up
rm -f ./amazon-cloudwatch-agent.rpm

echo "CloudWatch Agent installed successfully"
echo "Note: Configuration will be done via user-data script or SSM Parameter Store"
