# Time MCP Server

A Model Context Protocol server that provides time and timezone conversion capabilities. This server enables LLMs to get current time information and perform timezone conversions using IANA timezone names, with automatic system timezone detection.

## Features

- Get current time information
- Convert times between different timezones
- Uses IANA timezone database for accurate conversions
- Automatic system timezone detection

## Installation

```bash
# With MCP CLI
mcp install-registry time

# Manual installation with NPX
npx -y @modelcontextprotocol/server-time
```

## Configuration

No API keys or special configuration is required for the Time MCP Server. It uses the system's timezone by default.

### Customization - System Timezone

You can override the system timezone by setting the `TZ` environment variable:

```bash
export TZ="America/New_York"
```

## Tools

The Time MCP Server provides the following tools:

- `get_current_time`: Get the current time in a specific timezone
- `convert_time`: Convert a time from one timezone to another
- `list_timezones`: List available IANA timezones

## Example Usage

### Getting Current Time

```
What time is it in Tokyo right now?
```

### Converting Time Between Timezones

```
Convert 3:30 PM EST to Paris time.
```

### Working with Dates

```
What is the time difference between Los Angeles and Sydney, Australia?
```

## License

MIT License
