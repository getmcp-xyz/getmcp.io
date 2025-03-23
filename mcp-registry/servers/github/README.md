# GitHub MCP Server

MCP Server for the GitHub API, enabling file operations, repository management, search functionality, and more.

## Features

- Search GitHub repositories, code, issues, and users
- View repository contents and file structure
- Get information about users, organizations, and repositories
- Create, edit, and delete files within repositories
- Clone repositories
- Search code with powerful query syntax

## Installation

```bash
# With MCP CLI
mcp install-registry github

# Manual installation with NPX
npx -y @modelcontextprotocol/server-github
```

## Configuration

### GitHub Personal Access Token

This server requires a GitHub Personal Access Token with appropriate permissions. You can create one at https://github.com/settings/tokens.

Required permissions:
- `repo` (Full control of private repositories)
- `read:org` (Read-only access to organization membership)
- `read:user` (Read-only access to user data)

Set the token as an environment variable:

```bash
export GITHUB_TOKEN=your_token_here
```

## Tools

The GitHub MCP Server provides the following tools:

- `search_repositories`: Search GitHub repositories
- `search_code`: Search code within repositories
- `search_issues`: Search issues and pull requests
- `search_users`: Search GitHub users
- `get_repository`: Get repository information
- `get_file_contents`: Get contents of a file
- `list_repository_contents`: List files and directories in a repository
- `get_user`: Get user information
- `create_file`: Create a new file in a repository
- `update_file`: Update an existing file in a repository
- `delete_file`: Delete a file from a repository

## Search Query Syntax

### Code Search

```
language:python web scraping
filename:requirements.txt requests
org:google
```

### Issues Search

```
is:issue is:open label:bug
author:username
repo:owner/repo
```

### Users Search

```
location:san francisco
language:javascript
followers:>100
```

## Example Usage

### Search Repositories

```
Find popular machine learning repositories with more than 5000 stars that were updated in the last month.
```

### View File Contents

```
Show me the README.md file from the tensorflow/tensorflow repository.
```

## License

MIT License
