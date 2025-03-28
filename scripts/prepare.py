#!/usr/bin/env python3

import json
import os
import sys
from pathlib import Path
from typing import Dict, List

import requests

# Constants
GITHUB_API_URL = "https://api.github.com/graphql"
BATCH_SIZE = 50  # Process repositories in batches of 50 to avoid rate limits

def error_exit(message: str) -> None:
    """Print error message and exit with error code"""
    print(f"❌ {message}")
    sys.exit(1)

def status_message(message: str) -> None:
    """Print status message"""
    print(f"🔄 {message}")

def load_manifest(manifest_path: Path) -> Dict:
    """Load and parse a manifest file"""
    try:
        with open(manifest_path, 'r') as f:
            return json.load(f)
    except json.JSONDecodeError as e:
        error_exit(f"Invalid JSON in {manifest_path}: {e}")
    except Exception as e:
        error_exit(f"Error reading manifest file {manifest_path}: {e}")

def find_server_manifests(servers_dir: Path) -> List[Path]:
    """Find all server manifest files in the servers directory"""
    if not servers_dir.exists() or not servers_dir.is_dir():
        error_exit(f"Servers directory not found: {servers_dir}")
    
    server_files = []
    for file_path in servers_dir.glob('*.json'):
        if file_path.is_file():
            server_files.append(file_path)
    
    return server_files

def extract_github_repos(server_manifests: List[Path]) -> Dict[str, str]:
    """Extract GitHub repository URLs from server manifests"""
    github_repos = {}
    
    for manifest_path in server_manifests:
        server_name = manifest_path.stem  # Get filename without extension
        manifest = load_manifest(manifest_path)
        
        # Check if manifest has GitHub repository URL
        if 'repository' in manifest:
            repo_url = manifest['repository']
            
            # Handle both string and dictionary repository formats
            if isinstance(repo_url, str) and repo_url.startswith('https://github.com/'):
                github_repos[server_name] = repo_url
            elif isinstance(repo_url, dict) and 'url' in repo_url and isinstance(repo_url['url'], str) and repo_url['url'].startswith('https://github.com/'):
                github_repos[server_name] = repo_url['url']
    
    return github_repos

def fetch_github_stars_batch(repo_urls: List[str]) -> Dict[str, int]:
    """Fetch GitHub stars for multiple repositories using GraphQL API"""
    # Get GitHub token from environment variable
    github_token = os.environ.get('GITHUB_TOKEN')
    
    # Prepare headers
    headers = {
        'Content-Type': 'application/json',
    }
    
    # Add authorization if token is provided
    if github_token:
        headers['Authorization'] = f"Bearer {github_token}"
    
    # Extract owner and repo from URLs
    repos = []
    for url in repo_urls:
        if url.startswith('https://github.com/'):
            parts = url.replace('https://github.com/', '').split('/')
            if len(parts) >= 2:
                owner, repo = parts[0], parts[1]
                repos.append((owner, repo))
    
    if not repos:
        return {}
    
    stars = {}
    
    # Process repositories in batches
    for batch_start in range(0, len(repos), BATCH_SIZE):
        batch = repos[batch_start:batch_start + BATCH_SIZE]
        
        # Construct GraphQL query
        query_parts = []
        variables = {}
        
        for i, (owner, repo) in enumerate(batch):
            query_parts.append(f"""
            repo{i}: repository(owner: $owner{i}, name: $repo{i}) {{
                stargazerCount
                url
            }}
            """)
            variables[f"owner{i}"] = owner
            variables[f"repo{i}"] = repo
        
        query = f"""
        query ({', '.join(f'$owner{i}: String!, $repo{i}: String!' for i in range(len(batch)))}) {{
            {' '.join(query_parts)}
        }}
        """
        
        # Send GraphQL request
        try:
            response = requests.post(
                GITHUB_API_URL,
                headers=headers,
                json={'query': query, 'variables': variables}
            )
            
            # Check for errors
            if response.status_code != 200:
                if response.status_code == 401:
                    print(f"⚠️ GitHub API authentication failed. Set GITHUB_TOKEN environment variable for higher rate limits.")
                elif response.status_code == 403:
                    print(f"⚠️ GitHub API rate limit exceeded. Set GITHUB_TOKEN environment variable for higher rate limits.")
                else:
                    print(f"⚠️ GitHub API request failed with status {response.status_code}: {response.text}")
                continue
            
            data = response.json()
            
            # Check for GraphQL errors
            if 'errors' in data:
                print(f"⚠️ GraphQL errors: {data['errors']}")
                continue
            
            # Extract star counts
            for i, (owner, repo) in enumerate(batch):
                repo_key = f"repo{i}"
                if repo_key in data['data'] and data['data'][repo_key]:
                    url = data['data'][repo_key]['url']
                    star_count = data['data'][repo_key]['stargazerCount']
                    stars[url] = star_count
        
        except Exception as e:
            print(f"⚠️ Error fetching GitHub stars for batch: {e}")
    
    return stars

def get_github_stars(github_repos: Dict[str, str]) -> Dict[str, int]:
    """Fetch GitHub stars for all repositories"""
    if not github_repos:
        return {}
    
    status_message(f"Fetching GitHub stars for {len(github_repos)} repositories...")
    
    # Convert dict values to list for batch processing
    repo_urls = list(github_repos.values())
    
    # Fetch stars
    url_to_stars = fetch_github_stars_batch(repo_urls)
    
    # Map server names to star counts
    server_stars = {}
    for server_name, repo_url in github_repos.items():
        if repo_url in url_to_stars:
            server_stars[server_name] = url_to_stars[repo_url]
    
    return server_stars

def generate_servers_json(server_manifests: List[Path], output_path: Path) -> Dict[str, Dict]:
    """Generate servers.json file with server metadata"""
    status_message("Generating servers.json...")
    
    servers_data = {}
    
    for manifest_path in server_manifests:
        server_name = manifest_path.stem  # Get filename without extension
        manifest = load_manifest(manifest_path)
        
        # Extract relevant fields
        server_info = {
            'name': manifest.get('name', server_name),
            'description': manifest.get('description', ''),
            'version': manifest.get('version'),
            'repository': manifest.get('repository', ''),
            'author': manifest.get('author', ''),
            'categories': manifest.get('categories', []),
            'tags': manifest.get('tags', [])
        }
        
        servers_data[server_name] = server_info
    
    # Write servers.json
    with open(output_path, 'w') as f:
        json.dump(servers_data, f, indent=2)
    
    return servers_data

def generate_stars_json(stars: Dict[str, int], output_path: Path) -> None:
    """Generate stars.json file with GitHub star counts"""
    status_message("Generating stars.json...")
    
    # Write stars.json
    with open(output_path, 'w') as f:
        json.dump(stars, f, indent=2)

def main() -> None:
    """Main function to prepare site data"""
    if len(sys.argv) < 3:
        error_exit("Usage: prepare.py <source_dir> <target_dir> [--skip-stars]")
    
    source_dir = Path(sys.argv[1])
    target_dir = Path(sys.argv[2])
    skip_stars = "--skip-stars" in sys.argv
    
    # Find server manifests
    servers_dir = source_dir / "servers"
    server_manifests = find_server_manifests(servers_dir)
    
    if not server_manifests:
        error_exit(f"No server manifests found in {servers_dir}")
    
    # Generate servers.json
    servers_json_path = target_dir / "api" / "servers.json"
    generate_servers_json(server_manifests, servers_json_path)
    
    # Extract GitHub repositories
    github_repos = extract_github_repos(server_manifests)
    
    # Generate stars.json (if not skipped)
    stars_json_path = target_dir / "api" / "stars.json"
    
    if skip_stars and stars_json_path.exists():
        status_message("Skipping GitHub stars fetch as requested.")
    else:
        # Fetch GitHub stars
        stars = get_github_stars(github_repos)
        generate_stars_json(stars, stars_json_path)
    
    print("✅ Site preparation completed successfully!")

if __name__ == "__main__":
    main()
