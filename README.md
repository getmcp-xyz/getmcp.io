# getmcp.io
[![Validate](https://github.com/getmcp-xyz/getmcp.io/actions/workflows/validate-manifests.yml/badge.svg)](https://github.com/getmcp-xyz/getmcp.io/actions/workflows/validate-manifests.yml)
[![Deploy](https://github.com/getmcp-xyz/getmcp.io/actions/workflows/deploy.yml/badge.svg)](https://github.com/getmcp-xyz/getmcp.io/actions/workflows/deploy.yml)

Open Source Model Context Protocol (MCP) registry where you can discover, browse, and install MCP servers for AI assistants.

## Project Structure

```
getmcp.io/
├── mcp-registry/           # MCP server registry directory
│   ├── servers/            # Individual MCP servers
│   ├── schema/             # Schema definitions
│   └── tools/              # Helper scripts
└── pages/                  # Website pages
    ├── index.html          # Landing page
    └── registry/           # Registry UI pages
```

## Development

See [DEVELOPMENT.md](DEVELOPMENT.md) for setup and local development instructions.

## Contributing

Please see [Contributing Guidelines](/mcp-registry/CONTRIBUTING.md) for information on how to add or update MCP servers in the registry.
