#!/bin/bash

# Get project name from folder name
PROJECT_NAME=$(basename "$PWD")

# Stop and remove containers, volumes, and networks
docker compose down --volumes

# Remove any remaining volumes
docker volume ls --filter "name=${PROJECT_NAME}" -q | xargs -r docker volume rm

# Remove any remaining networks
docker network ls --filter "name=${PROJECT_NAME}" -q | xargs -r docker network rm

echo "Cleanup complete for project: $PROJECT_NAME"