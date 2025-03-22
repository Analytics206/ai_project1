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

# Create README.md with project name and service access information
echo "# $PROJECT_NAME" > README.md
echo "" >> README.md
echo "## Service Access Information" >> README.md
echo "Here are the URLs to access the services in this project:" >> README.md
echo "" >> README.md

# Parse docker-compose.yml and extract service access information
if command -v yq &> /dev/null; then
  yq -r '.services | keys[]' docker-compose.yml | while read -r service_name; do
    ports=$(yq -r ".services[\"$service_name\"].ports | @csv" docker-compose.yml | tr -d '"')
    if [ -n "$ports" ]; then
      echo "$ports" | tr ',' '\n' | while read -r port_mapping; do
        host_port=$(echo "$port_mapping" | cut -d':' -f1)
        echo "- **$service_name**: http://localhost:$host_port" >> README.md
      done
    fi
  done
else
  echo "Error: yq is not installed. Please install yq to generate service access information."
fi

# Create SERVICEME.md with service details
SERVICEME_FILE="services/SERVICEME.md"
echo "# Services in $PROJECT_NAME" > "$SERVICEME_FILE"
echo "This file lists all the services, networks, and volumes defined in the \`docker-compose.yml\` file, along with useful Docker commands for managing the environment." >> "$SERVICEME_FILE"
echo "" >> "$SERVICEME_FILE"

# Add service details
echo "## Services" >> "$SERVICEME_FILE"
echo "| Service Name | Container Name | Port Address | Access URL |" >> "$SERVICEME_FILE"
echo "|--------------|----------------|--------------|------------|" >> "$SERVICEME_FILE"

# Parse docker-compose.yml and extract service details
if command -v yq &> /dev/null; then
  yq -r '.services | keys[]' docker-compose.yml | while read -r service_name; do
    container_name=$(yq -r ".services[\"$service_name\"].container_name" docker-compose.yml)
    ports=$(yq -r ".services[\"$service_name\"].ports | @csv" docker-compose.yml | tr -d '"')
    
    # Substitute ${PROJECT_NAME} and ${OPENWEBUI_PORT} in container_name and ports
    container_name=$(echo "$container_name" | sed "s/\${PROJECT_NAME}/$PROJECT_NAME/g")
    ports=$(echo "$ports" | sed "s/\${PROJECT_NAME}/$PROJECT_NAME/g" | sed "s/\${OPENWEBUI_PORT}/$OPENWEBUI_PORT/g")
    
    # Generate access URLs
    access_urls=""
    if [ -n "$ports" ]; then
      echo "$ports" | tr ',' '\n' | while read -r port_mapping; do
        host_port=$(echo "$port_mapping" | cut -d':' -f1)
        access_urls+="http://localhost:$host_port, "
      done
      access_urls=$(echo "$access_urls" | sed 's/, $//')  # Remove trailing comma
    fi
    
    # Add service details to the table
    echo "| $service_name | $container_name | $ports | $access_urls |" >> "$SERVICEME_FILE"
  done
else
  echo "Error: yq is not installed. Please install yq to generate SERVICEME.md."
fi

# Add network details
echo "" >> "$SERVICEME_FILE"
echo "## Networks" >> "$SERVICEME_FILE"
echo "| Network Name |" >> "$SERVICEME_FILE"
echo "|--------------|" >> "$SERVICEME_FILE"
yq -r '.networks | keys[]' docker-compose.yml | while read -r network_name; do
  echo "| $network_name |" >> "$SERVICEME_FILE"
done

# Add volume details
echo "" >> "$SERVICEME_FILE"
echo "## Volumes" >> "$SERVICEME_FILE"
echo "| Volume Name |" >> "$SERVICEME_FILE"
echo "|-------------|" >> "$SERVICEME_FILE"
yq -r '.volumes | keys[]' docker-compose.yml | while read -r volume_name; do
  echo "| $volume_name |" >> "$SERVICEME_FILE"
done

# Add useful Docker commands
echo "" >> "$SERVICEME_FILE"
echo "## Useful Docker Commands" >> "$SERVICEME_FILE"
echo "### Start the environment" >> "$SERVICEME_FILE"
echo '```bash' >> "$SERVICEME_FILE"
echo "docker compose up -d" >> "$SERVICEME_FILE"
echo '```' >> "$SERVICEME_FILE"

echo "" >> "$SERVICEME_FILE"
echo "### Stop the environment" >> "$SERVICEME_FILE"
echo '```bash' >> "$SERVICEME_FILE"
echo "docker compose down" >> "$SERVICEME_FILE"
echo '```' >> "$SERVICEME_FILE"

echo "" >> "$SERVICEME_FILE"
echo "### Stop and remove all containers, networks, and volumes" >> "$SERVICEME_FILE"
echo '```bash' >> "$SERVICEME_FILE"
echo "docker compose down --volumes" >> "$SERVICEME_FILE"
echo '```' >> "$SERVICEME_FILE"

echo "" >> "$SERVICEME_FILE"
echo "### View logs for a specific service" >> "$SERVICEME_FILE"
echo '```bash' >> "$SERVICEME_FILE"
echo "docker compose logs <service_name>" >> "$SERVICEME_FILE"
echo '```' >> "$SERVICEME_FILE"

echo "" >> "$SERVICEME_FILE"
echo "### Remove a specific volume" >> "$SERVICEME_FILE"
echo '```bash' >> "$SERVICEME_FILE"
echo "docker volume rm <volume_name>" >> "$SERVICEME_FILE"
echo '```' >> "$SERVICEME_FILE"

echo "" >> "$SERVICEME_FILE"
echo "### Remove a specific network" >> "$SERVICEME_FILE"
echo '```bash' >> "$SERVICEME_FILE"
echo "docker network rm <network_name>" >> "$SERVICEME_FILE"
echo '```' >> "$SERVICEME_FILE"

# Start Docker containers
docker compose up -d

echo "Environment setup complete for project: $PROJECT_NAME"