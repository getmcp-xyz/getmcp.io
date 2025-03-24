#!/bin/bash

echo -e "\n📦 Setting up getmcp.io development environment...\n"

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

# Run the common preparation script
mkdir -p "$DEV_DIR/registry"
./scripts/prepare.sh "$DEV_DIR"

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
