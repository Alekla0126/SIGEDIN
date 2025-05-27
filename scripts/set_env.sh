#!/bin/bash

# This script sets up the environment configuration for the app
# Usage: ./scripts/set_env.sh [dev|staging|prod]

ENV=$1

if [ -z "$ENV" ]; then
  echo "Please specify environment: dev, staging, or prod"
  exit 1
fi

# Create .env file with the appropriate configuration
case $ENV in
  dev)
    echo "API_BASE_URL=http://10.0.2.2:8000" > .env
    echo "ENV=development" >> .env
    ;;
  staging)
    echo "API_BASE_URL=https://staging.api.yourdomain.com" > .env
    echo "ENV=staging" >> .env
    ;;
  prod)
    echo "API_BASE_URL=https://api.yourdomain.com" > .env
    echo "ENV=production" >> .env
    ;;
  *)
    echo "Invalid environment. Use dev, staging, or prod."
    exit 1
    ;;
esac

echo "Environment set to $ENV"
