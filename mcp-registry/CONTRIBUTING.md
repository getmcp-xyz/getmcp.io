# Contributing to getmcp.io Server Registry

Thank you for considering contributing to the getmcp.io Server Registry! This document outlines the process for adding or updating MCP servers in the registry.

## Adding a New Server

1. Fork this repository
2. Create a new directory under `mcp-registry/servers/` with your server's name (use kebab-case, e.g., `github` or `time-converter`)
3. Add the following files to your server directory:
   - `manifest.json`: Server metadata and configuration (see schema below)
   - `README.md`: Detailed documentation for your server

### manifest.json Requirements

Your `manifest.json` file must adhere to the [manifest schema](/mcp-registry/schema/manifest-schema.json) and include the following information:

```json
{
  "name": "your-server-name",
  "display_name": "Your Server Name",
  "version": "1.0.0",
  "description": "Brief description of the server's functionality",
  "repository": {
    "type": "git",
    "url": "https://github.com/your-username/your-repo"
  },
  "homepage": "https://github.com/your-username/your-repo#readme",
  "author": {
    "name": "Your Name",
    "email": "optional@email.com",
    "url": "https://optional-website.com"
  },
  "license": "MIT",
  "categories": ["category1", "category2"],
  "tags": ["tag1", "tag2"],
  "requirements": {
    "api_key": true,
    "authentication": "bearer_token"
  },
  "installation": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/your-server-name"],
    "package": "@modelcontextprotocol/your-server-name",
    "env": {
      "API_KEY": "${API_KEY}"
    }
  },
  "examples": [
    {
      "title": "Example usage",
      "description": "Brief description of example",
      "prompt": "Example prompt to demonstrate server functionality"
    }
  ]
}
```

### README.md Requirements

Your README.md should include:

1. **Overview**: What your server does and its main features
2. **Installation**: How to install and set up your server
3. **Configuration**: How to configure your server
4. **Tools and Resources**: Description of tools and resources provided
5. **Usage Examples**: Common use cases and example interactions
6. **Authentication**: Details about any required API keys or authentication methods
7. **License**: Information about your server's license

## Updating an Existing Server

1. Fork this repository
2. Update the relevant files in your server's directory
3. Submit a pull request with a clear description of your changes

## Validation

Before submitting your pull request, please validate your manifest.json file:

```bash
# From the repository root
npm run validate-manifest mcp-registry/servers/your-server-name/manifest.json
```

## Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## License

By contributing to this repository, you agree to license your contributions under the same license as this repository.
