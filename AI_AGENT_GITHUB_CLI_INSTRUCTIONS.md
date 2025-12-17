# AI Agent Instructions for GitHub CLI Integration

## Overview

You have access to the **GitHub CLI (`gh`)** command-line tool in your terminal environment. This powerful tool allows you to interact with GitHub repositories, issues, pull requests, workflows, and more directly from the command line.

## Authentication

### Important Note on Authentication

If any `gh` command fails due to authentication issues (not being logged in), the error will appear in the agent logs. **The user will be able to read these logs and take appropriate action** to authenticate their GitHub CLI session.

**Common authentication errors you might encounter:**
- `To get started with GitHub CLI, please run: gh auth login`
- `authentication required`
- `HTTP 401: Unauthorized`

**When you see these errors:**
1. The command execution will fail
2. The error message will be logged
3. Continue with your task as best as possible
4. The user will see the authentication error and can run `gh auth login` manually if needed

## Available Capabilities

The GitHub CLI provides extensive functionality across multiple domains:

### 1. Repository Operations

```bash
# View repository information
gh repo view [<repository>] [flags]

# Clone a repository
gh repo clone <repository>

# Create a new repository
gh repo create [<name>] [flags]

# Fork a repository
gh repo fork [<repository>] [flags]

# List repositories
gh repo list [<owner>] [flags]

# Sync a fork
gh repo sync [flags]
```

### 2. Issue Management

```bash
# Create an issue
gh issue create [flags]
gh issue create --title "Bug: Login fails" --body "Description of the bug"

# List issues
gh issue list [flags]
gh issue list --state open --label bug
gh issue list --assignee @me

# View an issue
gh issue view <number> [flags]

# Edit an issue
gh issue edit <number> [flags]

# Close an issue
gh issue close <number>

# Reopen an issue
gh issue reopen <number>

# Add comment to an issue
gh issue comment <number> --body "Comment text"

# Transfer an issue
gh issue transfer <number> <destination-repo>
```

### 3. Pull Request Operations

```bash
# Create a pull request
gh pr create [flags]
gh pr create --title "Fix login bug" --body "Description" --base main

# List pull requests
gh pr list [flags]
gh pr list --state open --label "needs-review"

# View a pull request
gh pr view [<number>] [flags]

# Checkout a pull request locally
gh pr checkout <number>

# Review a pull request
gh pr review [<number>] [flags]
gh pr review 123 --approve
gh pr review 123 --request-changes --body "Please fix..."
gh pr review 123 --comment --body "Looks good!"

# Merge a pull request
gh pr merge [<number>] [flags]
gh pr merge 123 --squash
gh pr merge 123 --merge
gh pr merge 123 --rebase

# Close a pull request
gh pr close <number>

# Reopen a pull request
gh pr reopen <number>

# Check PR status
gh pr status

# Add a comment
gh pr comment <number> --body "Comment text"
```

### 4. GitHub Actions & Workflows

```bash
# List workflow runs
gh run list [flags]

# View a specific run
gh run view [<run-id>] [flags]

# Watch a run in real-time
gh run watch <run-id>

# Rerun a workflow
gh run rerun <run-id>

# Download run artifacts
gh run download [<run-id>]

# List workflows
gh workflow list

# View workflow
gh workflow view <workflow>

# Run a workflow
gh workflow run <workflow> [flags]

# Enable/disable workflow
gh workflow enable <workflow>
gh workflow disable <workflow>
```

### 5. Releases

```bash
# Create a release
gh release create <tag> [<files>...] [flags]

# List releases
gh release list [flags]

# View a release
gh release view [<tag>] [flags]

# Download release assets
gh release download [<tag>] [flags]

# Upload assets to a release
gh release upload <tag> <files>...

# Delete a release
gh release delete <tag>
```

### 6. Gist Operations

```bash
# Create a gist
gh gist create [<filename>...] [flags]

# List gists
gh gist list [flags]

# View a gist
gh gist view <gist-id>

# Edit a gist
gh gist edit <gist-id>

# Delete a gist
gh gist delete <gist-id>
```

### 7. Project Operations (GitHub Projects)

```bash
# List projects
gh project list [flags]

# View a project
gh project view <number> [flags]

# Create a project
gh project create [flags]

# Close/reopen a project
gh project close <number>
gh project reopen <number>
```

### 8. API Access

```bash
# Make authenticated GitHub API requests
gh api <endpoint> [flags]

# Examples:
gh api repos/:owner/:repo/issues
gh api user
gh api /repos/:owner/:repo/commits
```

## Common Usage Patterns

### Working with the Current Repository

When you're in a git repository directory, many `gh` commands automatically detect the context:

```bash
# These commands work in the current repo context
gh issue list
gh pr list
gh pr create
gh repo view
```

### Specifying a Repository

You can specify a repository explicitly:

```bash
gh issue list --repo owner/repo-name
gh pr view 123 --repo owner/repo-name
```

### Using Flags and Filters

Most commands support rich filtering and formatting:

```bash
# Filter issues
gh issue list --label bug --state open --assignee @me

# Format output as JSON
gh issue list --json number,title,state

# Use JQ for advanced processing
gh api repos/:owner/:repo/issues | jq '.[] | .title'

# Limit results
gh pr list --limit 10
```

### Interactive Mode

Many commands support interactive selection when you don't provide required arguments:

```bash
# Will prompt you to select an issue
gh issue view

# Will prompt you to select a PR
gh pr checkout
```

## Best Practices for AI Agent Usage

### 1. Error Handling

Always be prepared for authentication errors:

```bash
# When running gh commands, check the output
# If authentication fails, the error will be logged
# User can then run: gh auth login
```

### 2. Repository Context

Ensure you're in the correct directory or specify the repository:

```bash
# Change to repo directory first
cd /path/to/repo
gh issue list

# OR specify repo explicitly
gh issue list --repo owner/repo
```

### 3. Automation-Friendly Flags

Use flags that make automation easier:

```bash
# Non-interactive mode
gh pr create --title "..." --body "..." --base main

# JSON output for parsing
gh issue list --json number,title,state,labels

# Specify values explicitly rather than relying on prompts
gh issue create --title "Bug" --body "Description" --label bug
```

### 4. Checking Status Before Actions

```bash
# Check if repo exists
gh repo view owner/repo

# Check issue status before editing
gh issue view 123

# Check PR status
gh pr status
```

### 5. Pagination

Be aware of default limits and use pagination:

```bash
# Get more results
gh issue list --limit 100

# Get all results (use with caution)
gh issue list --limit 1000
```

## Integration with Other AI Agent Workflows

### With Jira Integration

```bash
# Create GitHub issue from Jira ticket
gh issue create --title "$JIRA_SUMMARY" --body "$JIRA_DESCRIPTION"

# Link in comments
gh issue comment 123 --body "Related to Jira: PROJ-123"
```

### With Knowledge Graph

```bash
# Create documentation issue
gh issue create --title "Update knowledge graph for feature X" --label documentation

# Reference code changes in issues
gh issue comment 456 --body "Updated docs in knowledge-graph/components/..."
```

### With CI/CD

```bash
# Trigger workflow
gh workflow run build.yml

# Monitor deployment
gh run watch <run-id>

# Check workflow status before merging
gh pr checks 123
```

## Troubleshooting

### Authentication Issues

**Error:** `To get started with GitHub CLI, please run: gh auth login`

**Resolution:** This error will appear in the logs. The user needs to:
```bash
gh auth login
# Follow the interactive prompts
```

**Error:** `HTTP 401: Unauthorized`

**Resolution:** Token may have expired. User should re-authenticate:
```bash
gh auth refresh
# or
gh auth login --force
```

### Permission Issues

**Error:** `Resource not accessible by integration`

**Resolution:** The token may lack required scopes. User needs to:
```bash
gh auth refresh -s repo -s workflow -s project
```

### Repository Not Found

**Error:** `Could not resolve to a Repository`

**Resolution:** 
- Check repository name spelling
- Ensure you have access to the repository
- Verify the repository exists

### Rate Limiting

**Error:** `API rate limit exceeded`

**Resolution:** 
- Wait for rate limit to reset
- User may need to authenticate to get higher limits

## Examples of AI Agent Tasks

### Task 1: Create Issue from Bug Report

```bash
gh issue create \
  --title "Bug: Authentication fails with OAuth" \
  --body "Users report authentication failures when using OAuth providers..." \
  --label bug \
  --label urgent \
  --assignee @me
```

### Task 2: Update PR with Review Comments

```bash
# Get PR details
gh pr view 123

# Add review comments
gh pr review 123 --comment --body "Please update the tests to cover edge cases"
```

### Task 3: Monitor Workflow Execution

```bash
# List recent runs
gh run list --limit 5

# Watch specific run
gh run watch 123456

# Download artifacts if needed
gh run download 123456
```

### Task 4: Create Release

```bash
# Create a new release
gh release create v1.2.0 \
  --title "Version 1.2.0" \
  --notes "Bug fixes and improvements" \
  ./dist/*.zip
```

### Task 5: Bulk Operations

```bash
# Close multiple stale issues
gh issue list --label stale --json number --jq '.[].number' | \
  xargs -I {} gh issue close {}

# List all open PRs and their status
gh pr list --json number,title,state,reviews
```

## Reference

### Official Documentation
- GitHub CLI Manual: https://cli.github.com/manual/
- GitHub CLI Repository: https://github.com/cli/cli

### Common Flags (Universal)

- `--help, -h`: Show help for any command
- `--repo <owner/repo>, -R`: Specify repository
- `--json <fields>`: Output as JSON
- `--jq <expression>`: Filter JSON output
- `--web, -w`: Open in web browser

### Environment Variables

- `GH_TOKEN`: GitHub token for authentication
- `GH_REPO`: Default repository
- `GH_HOST`: GitHub host (for Enterprise)

## Summary

You have full access to the GitHub CLI (`gh`) and can use it to:
- ✅ Manage issues and pull requests
- ✅ Trigger and monitor workflows
- ✅ Create releases
- ✅ Interact with the GitHub API
- ✅ Automate repository operations

**Remember:** If authentication fails, the error will be logged and the user will handle authentication setup. Continue with your tasks and provide helpful error messages when authentication is needed.
