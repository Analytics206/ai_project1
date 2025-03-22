#!/bin/bash

# Get project name from folder name
PROJECT_NAME=$(basename "$PWD")

# Create folder structure
mkdir -p .devcontainer .vscode services/postgres services/mongodb services/qdrant services/neo4j services/redis services/kafka services/openwebui services/logging data models notebooks scripts src tests

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
  cp .env.template .env
fi

# Update PROJECT_NAME in .env
if grep -q "PROJECT_NAME=" .env; then
  sed -i "s/^PROJECT_NAME=.*/PROJECT_NAME=$PROJECT_NAME/" .env
else
  echo "PROJECT_NAME=$PROJECT_NAME" >> .env
fi

# Start Docker containers
docker compose up -d

echo "Environment setup complete for project: $PROJECT_NAME"