#!/bin/bash

# Check if project name is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <project-name>"
  exit 1
fi

PROJECT_NAME=$1

# Stop and remove containers associated with the project
echo "Stopping and removing containers for project: $PROJECT_NAME"
docker compose -p $PROJECT_NAME down

# Remove all volumes associated with the project
echo "Removing volumes for project: $PROJECT_NAME"
docker volume ls --filter "name=${PROJECT_NAME}_" --format "{{.Name}}" | xargs -r docker volume rm

# Remove all networks associated with the project
echo "Removing networks for project: $PROJECT_NAME"
docker network ls --filter "name=${PROJECT_NAME}_" --format "{{.Name}}" | xargs -r docker network rm

echo "Cleanup for project: $PROJECT_NAME completed."
