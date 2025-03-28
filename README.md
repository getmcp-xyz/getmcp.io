# getmcp.io
[![Validate](https://github.com/getmcp-xyz/getmcp.io/actions/workflows/validate-manifests.yml/badge.svg)](https://github.com/getmcp-xyz/getmcp.io/actions/workflows/validate-manifests.yml)
[![Deploy](https://github.com/getmcp-xyz/getmcp.io/actions/workflows/deploy.yml/badge.svg)](https://github.com/getmcp-xyz/getmcp.io/actions/workflows/deploy.yml)

Open Source Model Context Protocol (MCP) server registry where you can discover, browse, and install MCP servers for AI assistants.

## Project Structure

```
getmcp.io/
├── mcp-registry/           # MCP Server Registry directory
│   ├── servers/            # Individual MCP servers
│   ├── schema/             # Schema definitions
│   └── tools/              # Helper scripts
└── pages/                  # Website pages
    ├── index.html          # Landing page
    └── registry/           # Server Registry UI pages
```

## Development

See [DEVELOPMENT.md](DEVELOPMENT.md) for setup and local development instructions.

### GitHub API Access

When running the development server or build scripts, you can provide a GitHub token to avoid API rate limits when fetching repository star counts:

```bash
GITHUB_TOKEN=your_github_token ./dev.sh
```

Without a token, the site will still build but may not display star counts for all repositories.

## Contributing

Please see [Contributing Guidelines](/mcp-registry/CONTRIBUTING.md) for information on how to add or update MCP servers in the Server Registry.
