#!/usr/bin/env node

// This script generates the servers.json file from the server manifest files
// Now that we've moved the manifest.json files up one level and renamed them to [server].json

const fs = require('fs');
const path = require('path');

// Paths
const serversDir = path.join(__dirname, '../../mcp-registry/servers');
const outputFile = path.join(__dirname, './servers.json');

// Ensure the output directory exists
if (!fs.existsSync(path.dirname(outputFile))) {
  fs.mkdirSync(path.dirname(outputFile), { recursive: true });
}

// Read all .json files in the servers directory
const serverFiles = fs.readdirSync(serversDir)
  .filter(file => file.endsWith('.json'));

const serversMap = {};

// Process each server manifest file
serverFiles.forEach(file => {
  const filePath = path.join(serversDir, file);
  try {
    const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
    // Use the server name from the manifest as the key
    const serverName = data.name;
    serversMap[serverName] = data;
  } catch (error) {
    console.error(`Error processing ${file}:`, error.message);
  }
});

// Write the servers map to the output file
fs.writeFileSync(outputFile, JSON.stringify(serversMap, null, 2));
console.log(`Generated ${outputFile} with ${Object.keys(serversMap).length} servers`);
