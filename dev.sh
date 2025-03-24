#!/bin/bash

echo -e "\n📦 Setting up getmcp.io development environment...\n"

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "❌ jq is required but not installed. Please install it with 'brew install jq'"
    exit 1
fi

# Check if Docker is installed and running
if ! docker info &> /dev/null; then
    echo "❌ Docker is required but not running. Please start Docker and try again."
    exit 1
fi

# Cleanup previous development files
echo -e "🗑️ Cleaning up previously generated files...\n"
rm -rf pages/api/servers
rm -f pages/api/servers.json
rm -rf pages/registry/servers

# Create and clean _dev directory
DEV_DIR="_dev"
echo -e "🔄 Setting up development directory in $DEV_DIR\n"
mkdir -p "$DEV_DIR"

# First clear the directory to ensure clean state
rm -rf "$DEV_DIR"/*

# Copy pages directory structure with all content
echo -e "🔄 Copying site content to development directory...\n"
cp -r pages/* "$DEV_DIR"/

# Create API and registry directories if they don't exist
mkdir -p "$DEV_DIR/api/servers"
mkdir -p "$DEV_DIR/registry"

# Copy registry files to development directory
echo -e "🔄 Copying registry files...\n"
cp -r mcp-registry/* "$DEV_DIR/registry/"

# Create API endpoints for manifests
echo -e "🔄 Creating API endpoints...\n"
find mcp-registry/servers -name "manifest.json" -type f | while read manifest; do
  server_name=$(basename $(dirname "$manifest"))
  echo "  - Processing $server_name..."
  cp "$manifest" "$DEV_DIR/api/servers/$server_name.json"
done

# Create the combined servers.json file
echo -e "🔄 Generating combined servers.json...\n"
echo "[" > "$DEV_DIR/api/servers.json"
first=true
for manifest in $(find mcp-registry/servers -name "manifest.json" -type f | sort); do
  server_name=$(basename $(dirname "$manifest"))
  if [ "$first" = true ]; then
    first=false
  else
    echo "," >> "$DEV_DIR/api/servers.json"
  fi
  
  # Process the manifest to create server entry with additional frontend fields
  jq -c '. + {
    "name": .name,
    "displayName": .display_name,
    "tags": .tags,
    "repository": .repository.url,
    "documentation": "/registry/servers/\(.name)/",
    "apiEndpoint": "/api/servers/\(.name).json"
  }' "$manifest" >> "$DEV_DIR/api/servers.json"
done
echo "]" >> "$DEV_DIR/api/servers.json"

echo -e "✅ Setup complete!\n"
# Check if port 4000 is already in use
if lsof -i :4000 > /dev/null 2>&1; then
    echo -e "⚠️ Port 4000 is already in use!\n"
    echo "Would you like to stop any running Jekyll containers and try again? (y/n)"
    read -r response
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        echo "🗑️ Stopping any running Jekyll containers..."
        docker ps | grep jekyll | awk '{print $1}' | xargs -r docker stop
        echo "Waiting for port to be released..."
        sleep 3
    else
        echo "Exiting. Please stop the service using port 4000 and try again."
        exit 1
    fi
fi

echo -e "\n🌐 Starting Jekyll development server..."
echo "   Access the site at http://localhost:4000"
echo -e "   Press Ctrl+C to stop the server\n"

# Start Jekyll dev server using Docker from the _dev directory
cd "$DEV_DIR" && docker run --rm -it \
  -v "$PWD:/srv/jekyll" \
  -p 4000:4000 \
  jekyll/jekyll:4.2.0 \
  jekyll serve --livereload
