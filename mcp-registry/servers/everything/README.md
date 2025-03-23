# Everything MCP Server

This MCP server attempts to exercise all the features of the MCP protocol. It is not intended to be a useful server, but rather a test server for builders of MCP clients. It implements prompts, tools, resources, sampling, and more to showcase MCP capabilities.

## Components

### Tools

This server implements a wide variety of tools to demonstrate MCP capabilities:

- `echo`: Echoes back the provided message
- `add`: Adds two numbers together
- `fetch`: Fetches content from a URL
- `exception`: Always throws an exception
- `delayed_response`: Responds after a delay
- `identity`: Returns the input unchanged
- `multi_output`: Returns multiple outputs
- `resource_viewer`: Displays a resource

### Resources

The server provides various resource types for testing:

- Text resources
- Image resources
- JSON resources
- Binary resources

### Prompts

The server demonstrates various prompt formats:

- Simple text prompts
- Structured prompts with multiple fields
- Prompts with different sampling parameters

## Installation

```bash
# With MCP CLI
mcp install-registry everything

# Manual installation with NPX
npx -y @modelcontextprotocol/server-everything
```

## Usage with Claude Desktop

This server can be used with Claude Desktop to test MCP capabilities:

1. Start the server using NPX:
   ```
   npx -y @modelcontextprotocol/server-everything
   ```
   
2. In Claude Desktop, navigate to Settings > Developer > Context Providers
   
3. Add a new context provider with:
   - Name: "Everything"
   - URL: `http://localhost:8000` (or the URL shown in the server output)
   
4. Click "Connect" and start using the server capabilities

## Example Usage

### Test Tool Usage

```
Show me how to use the different tools available in this MCP server.
```

### Test Resources

```
Demonstrate how to access and use resources from this MCP server.
```

## License

MIT License
