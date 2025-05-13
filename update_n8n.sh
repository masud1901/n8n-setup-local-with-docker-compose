#!/bin/bash
set -e

# --- Configuration ---
COMPOSE_FILE="docker-compose.yml" # Path to your docker-compose.yml file (relative to script)
SERVICE_NAME="n8n" # Name of the service in docker-compose.yml
VOLUME_NAME="n8n_data" # Name of the Docker volume (defined in docker-compose.yml)
# --- End Configuration ---

echo "--- Starting n8n Update Script (using Docker Compose) ---"

# 1. Check if the n8n_data volume exists (CRITICAL)
echo "Checking if Docker volume '$VOLUME_NAME' exists..."
if ! docker volume inspect "$VOLUME_NAME" > /dev/null 2>&1; then
  echo "ERROR: Docker volume '$VOLUME_NAME' not found!"
  echo "This volume is essential for preserving your n8n data."
  echo "Ensure you initially started n8n using 'docker-compose up -d' with a docker-compose.yml that defines this volume."
  echo "Update script aborted. Data preservation is at risk without the volume."
  exit 1
else
  echo "Docker volume '$VOLUME_NAME' found. Data persistence should be ensured."
fi

# 2. Navigate to the directory containing docker-compose.yml
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # Get script directory
cd "$SCRIPT_DIR"

# 3. Stop and remove the existing services (using docker-compose down)
echo "Stopping and removing existing services using 'docker-compose down'..."
docker-compose down

# 4. Pull the latest n8n image (using docker-compose pull)
echo "Pulling latest n8n image using 'docker-compose pull'..."
docker-compose pull "$SERVICE_NAME"

# 5. Get and display the latest n8n version (optional)
echo "Getting latest n8n version..."
LATEST_VERSION=$(docker-compose run --rm "$SERVICE_NAME" n8n --version)
echo "Latest n8n version: $LATEST_VERSION"

# 6. Start the services using docker-compose up (in detached mode -d)
echo "Starting services using 'docker-compose up -d'..."
docker-compose up -d

echo "--- n8n Update Complete! (using Docker Compose) ---"
echo "You can access n8n at http://localhost:5678 (replace with your host if not localhost)"