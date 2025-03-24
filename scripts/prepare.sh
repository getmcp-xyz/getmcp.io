#!/bin/bash

# Function to display error messages
error_exit() {
  echo "❌ $1"
  exit 1
}

# Function to display status messages
status_message() {
  echo -e "🔄 $1"
}

# Check if jq is installed
check_dependencies() {
  if ! command -v jq &> /dev/null; then
    error_exit "jq is required but not installed. Please install it with 'brew install jq'"
  fi
}

# Set up the directory structure and copy necessary files
setup_directories() {
  TARGET_DIR="$1"
  
  # Create API and registry directories if they don't exist
  mkdir -p "$TARGET_DIR/api/servers"
  
  # Copy registry files to target directory
  status_message "Copying registry files..."
  cp -r mcp-registry/* "$TARGET_DIR/registry/"
  
  # Create API endpoints for manifests
  status_message "Creating API endpoints..."
  find mcp-registry/servers -name "manifest.json" -type f | while read manifest; do
    server_name=$(basename $(dirname "$manifest"))
    echo "  - Processing $server_name..."
    cp "$manifest" "$TARGET_DIR/api/servers/$server_name.json"
  done
}

# Generate the combined servers.json file as a map with server names as keys
generate_servers_json() {
  TARGET_DIR="$1"
  
  status_message "Generating combined servers.json..."
  echo "{" > "$TARGET_DIR/api/servers.json"
  first=true
  for manifest in $(find mcp-registry/servers -name "manifest.json" -type f | sort); do
    server_name=$(basename $(dirname "$manifest"))
    if [ "$first" = true ]; then
      first=false
    else
      echo "," >> "$TARGET_DIR/api/servers.json"
    fi
    
    # Process the manifest to create server entry with additional frontend fields
    echo -n "\"$server_name\": " >> "$TARGET_DIR/api/servers.json"
    jq -c '. + {
      "name": .name,
      "displayName": .display_name,
      "tags": .tags,
      "repository": .repository.url,
      "documentation": "/registry/servers/\(.name)/",
      "apiEndpoint": "/api/servers/\(.name).json"
    }' "$manifest" >> "$TARGET_DIR/api/servers.json"
  done
  echo "}" >> "$TARGET_DIR/api/servers.json"
}

# Main function to prepare the site
prepare_site() {
  TARGET_DIR="$1"
  
  # Check dependencies first
  check_dependencies
  
  # Setup directories and copy files
  setup_directories "$TARGET_DIR"
  
  # Generate servers.json
  generate_servers_json "$TARGET_DIR"
  
  echo -e "✅ Preparation complete!\n"
}

# If this script is executed directly, run the preparation
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  if [ -z "$1" ]; then
    error_exit "Target directory not specified. Usage: $0 <target_directory>"
  fi
  
  prepare_site "$1"
fi
