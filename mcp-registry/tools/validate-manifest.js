#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const Ajv = require('ajv');
const addFormats = require('ajv-formats');

// Read the manifest file path from command line arguments
const manifestPath = process.argv[2];

if (!manifestPath) {
  console.error('Error: No manifest file specified');
  console.error('Usage: validate-manifest.js path/to/manifest.json');
  process.exit(1);
}

// Read the schema
const schemaPath = path.join(__dirname, '..', 'schema', 'manifest-schema.json');
let schema;
try {
  schema = JSON.parse(fs.readFileSync(schemaPath, 'utf8'));
} catch (error) {
  console.error(`Error reading schema file: ${error.message}`);
  process.exit(1);
}

// Read the manifest
let manifest;
try {
  manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
} catch (error) {
  console.error(`Error reading manifest file: ${error.message}`);
  process.exit(1);
}

// Validate the manifest against the schema
const ajv = new Ajv({ allErrors: true });
addFormats(ajv);
const validate = ajv.compile(schema);
const valid = validate(manifest);

if (valid) {
  console.log(`✓ ${path.basename(manifestPath)} is valid`);
  process.exit(0);
} else {
  console.error(`✗ ${path.basename(manifestPath)} is invalid:`);
  validate.errors.forEach((error) => {
    console.error(`  - ${error.instancePath} ${error.message}`);
  });
  process.exit(1);
}
