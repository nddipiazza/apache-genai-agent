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

# Add a comment to a PR (useful for adding review information)
gh pr comment <number> --body "Comment text"

# Edit PR details (useful for adding review information to description)
gh pr edit <number> --body "Updated description with review info"
```

#### **Best Practice: Adding Code Review Information to PRs**

When creating a PR, always include comprehensive review information to help reviewers:

```bash
# Create PR with detailed review information
gh pr create \
  --title "PROJ-123: Add user authentication" \
  --body "## Summary
Implements JWT-based authentication for the user service.

## Changes
- Added AuthenticationService with JWT token generation
- Implemented login and logout endpoints
- Added role-based access control middleware
- Created comprehensive test suite

## Review Focus Areas
Please pay special attention to:
- [ ] **Security**: Token generation and validation logic in AuthenticationService.java
- [ ] **Error handling**: Exception handling in login/logout flows
- [ ] **Test coverage**: Edge cases for expired tokens and invalid credentials
- [ ] **Performance**: Token caching mechanism
- [ ] **Breaking changes**: None expected, all changes are additive

## Critical Files to Review
- \`src/main/java/com/example/auth/AuthenticationService.java\` - Core authentication logic
- \`src/main/java/com/example/auth/JWTTokenProvider.java\` - Token generation/validation
- \`src/test/java/com/example/auth/AuthenticationServiceTest.java\` - Test coverage

## Testing Instructions
\`\`\`bash
# Run all tests
mvn clean test

# Test authentication flow specifically
mvn test -Dtest=AuthenticationServiceTest

# Manual testing
curl -X POST http://localhost:8080/api/auth/login -d '{\"username\":\"test\",\"password\":\"pass\"}'
\`\`\`

## Review Checklist
- [ ] Code follows project style guidelines
- [ ] All tests pass
- [ ] No security vulnerabilities introduced
- [ ] Documentation is updated
- [ ] No unnecessary dependencies added

## Related Issues
- Closes PROJ-123
- Related to PROJ-100 (authentication epic)" \
  --base main \
  --head feature/PROJ-123-auth
```

#### **Adding Review Information After PR Creation**

If you need to add review information after the PR is created:

```bash
# Add a comprehensive review comment
gh pr comment 456 --body "## 🔍 Code Review Information

### Key Changes
- Modified payment processing to use transaction locking
- Added retry logic for failed transactions
- Updated error handling to be more specific

### Review Focus Areas
- **Thread Safety**: Please verify the locking mechanism in PaymentService.java (lines 45-67)
- **Error Handling**: Check the new exception types and error messages
- **Performance**: The retry logic may add latency - please review

### Critical Files
1. \`src/main/java/com/example/payment/PaymentService.java\` - Core changes
2. \`src/main/java/com/example/payment/TransactionLock.java\` - New locking mechanism
3. \`src/test/java/com/example/payment/PaymentServiceTest.java\` - Concurrency tests

### Testing
- All existing tests pass
- Added 5 new test cases for concurrent scenarios
- Manual testing with 100 concurrent requests: ✅ PASSED

### Potential Concerns
- ⚠️ The locking mechanism may impact throughput under very high load
- Consider monitoring transaction latency in production

Please review and let me know if you have any questions!"
```

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

### 3. Always Add Code Review Information to PRs

**IMPORTANT**: Every PR created by the agent must include comprehensive review information to help reviewers understand what to focus on.

**When creating a PR, you MUST include:**

1. **Summary** - What the PR does
2. **Changes** - Detailed list of modifications
3. **Review Focus Areas** - Specific items that need careful review
4. **Critical Files** - Files that are most important to review
5. **Testing Instructions** - How to test the changes
6. **Review Checklist** - Items to verify before approval
7. **Potential Concerns** - Performance, breaking changes, security issues

**Example workflow for every PR:**

```bash
# Step 1: Create the PR with comprehensive information
gh pr create \
  --title "PROJ-123: Feature description" \
  --body "$(cat << 'EOF'
## Summary
Brief description of what this PR does.

## Changes
- Change 1
- Change 2
- Added tests

## Review Focus Areas
- [ ] **Security**: Authentication logic changes
- [ ] **Performance**: Database query optimization
- [ ] **Breaking Changes**: API contract modifications

## Critical Files
- \`path/to/critical/file.java\` - Core logic
- \`path/to/test/file.java\` - Test coverage

## Testing Instructions
\`\`\`bash
mvn clean test
mvn test -Dtest=SpecificTest
\`\`\`

## Review Checklist
- [ ] Code follows style guidelines
- [ ] Tests pass
- [ ] Documentation updated

## Potential Concerns
- None expected, all changes are backward compatible
EOF
)" \
  --base main \
  --head feature/branch

# Step 2: Get the PR number
PR_NUMBER=$(gh pr list --head feature/branch --json number -q '.[0].number')

# Step 3: Optionally add a follow-up comment with additional context
gh pr comment $PR_NUMBER --body "## 🔍 Additional Review Notes

Please prioritize reviewing the error handling in the new service class. The retry logic is critical for production reliability.

CC: @team-lead for architectural review"
```

**Template for code review information:**

```markdown
## Summary
[One-line description of the change]

## Changes
- [Specific change 1]
- [Specific change 2]
- [Tests added/modified]

## Review Focus Areas
Please pay special attention to:
- [ ] **[Category 1]**: [What to review and why]
- [ ] **[Category 2]**: [What to review and why]
- [ ] **[Category 3]**: [What to review and why]

## Critical Files to Review
- \`path/to/file1\` - [Why this file is critical]
- \`path/to/file2\` - [Why this file is critical]

## Testing Instructions
\`\`\`bash
[Commands to run tests]
[Manual testing steps if applicable]
\`\`\`

## Review Checklist
- [ ] Code follows project style guidelines
- [ ] All tests pass
- [ ] Documentation updated
- [ ] No security vulnerabilities
- [ ] Performance impact assessed

## Potential Concerns
- [Any performance concerns]
- [Any breaking changes]
- [Any security considerations]
- Or: None expected
```

### 4. Automation-Friendly Flags

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
