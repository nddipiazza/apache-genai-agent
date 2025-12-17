# AI Agent Instructions for Apache JIRA Integration

## Prerequisites

1. **JIRA API Token Storage**: The JIRA API token is stored in `pass` under the key `jira/token`
   - Retrieve it using: `pass jira/token`
   
2. **Python Environment**: Python3 is installed with the `jira` pip package
   - Import using: `from jira import JIRA`

3. **Apache JIRA Server**: `https://issues.apache.org/jira`

## Reading a JIRA Ticket

Use Python with the jira package to read ticket information:

```python
from jira import JIRA
import subprocess

# Get the JIRA API token from pass
token = subprocess.check_output(['pass', 'jira/token']).decode('utf-8').strip()

# Connect to Apache JIRA
jira = JIRA(server='https://issues.apache.org/jira', token_auth=token)

# Get the ticket (e.g., TIKA-4579)
issue = jira.issue('TIKA-4579')

# Access ticket fields
print(f"Key: {issue.key}")
print(f"Summary: {issue.fields.summary}")
print(f"Status: {issue.fields.status.name}")
print(f"Reporter: {issue.fields.reporter.displayName}")
print(f"Assignee: {issue.fields.assignee.displayName if issue.fields.assignee else 'Unassigned'}")
print(f"Priority: {issue.fields.priority.name if issue.fields.priority else 'None'}")
print(f"Created: {issue.fields.created}")
print(f"Updated: {issue.fields.updated}")
print(f"Description: {issue.fields.description}")
print(f"Components: {[c.name for c in issue.fields.components]}")
print(f"Labels: {issue.fields.labels}")

# Read comments
if issue.fields.comment.comments:
    for comment in issue.fields.comment.comments:
        print(f"[{comment.author.displayName} - {comment.created}]")
        print(comment.body)
```

## Creating a JIRA Ticket

Use Python with the jira package to create new tickets:

```python
from jira import JIRA
import subprocess

# Get the JIRA API token from pass
token = subprocess.check_output(['pass', 'jira/token']).decode('utf-8').strip()

# Connect to Apache JIRA
jira = JIRA(server='https://issues.apache.org/jira', token_auth=token)

# Create a new ticket
new_issue = jira.create_issue(
    project='TIKA',
    summary='Brief summary of the issue',
    description='Detailed description of the issue\n\nCan include multiple lines',
    issuetype={'name': 'Bug'},  # or 'Task', 'Improvement', 'New Feature', etc.
    priority={'name': 'Major'},  # or 'Critical', 'Minor', 'Blocker', 'Trivial'
    components=[{'name': 'parser'}],  # Optional: list of component names
    labels=['label1', 'label2']  # Optional: list of labels
)

print(f"Created ticket: {new_issue.key}")
print(f"URL: https://issues.apache.org/jira/browse/{new_issue.key}")
```

## Common Issue Types for Apache Tika

- `Bug`: A problem in existing functionality
- `Improvement`: Enhancement to existing functionality
- `New Feature`: Completely new functionality
- `Task`: A general task
- `Test`: Test-related work
- `Wish`: Feature request

## Common Priority Levels

- `Blocker`: Blocks development/testing
- `Critical`: Critical issue
- `Major`: Major issue (default)
- `Minor`: Minor issue
- `Trivial`: Trivial issue

## Updating a JIRA Ticket

```python
from jira import JIRA
import subprocess

token = subprocess.check_output(['pass', 'jira/token']).decode('utf-8').strip()
jira = JIRA(server='https://issues.apache.org/jira', token_auth=token)

issue = jira.issue('TIKA-XXXX')

# Update fields
issue.update(summary='New summary', description='New description')

# Add a comment
jira.add_comment(issue, 'This is a comment')

# Assign to someone
issue.update(assignee={'name': 'username'})

# Change status (requires valid workflow transition)
jira.transition_issue(issue, 'In Progress')
```

## Adding Comments to a Ticket

```python
from jira import JIRA
import subprocess

token = subprocess.check_output(['pass', 'jira/token']).decode('utf-8').strip()
jira = JIRA(server='https://issues.apache.org/jira', token_auth=token)

issue = jira.issue('TIKA-4579')
jira.add_comment(issue, 'Your comment text here')
```

## Best Practices for AI Agents

1. **Always retrieve the token fresh** from `pass` for each operation
2. **Handle errors gracefully** - wrap JIRA calls in try/except blocks
3. **Verify ticket exists** before attempting updates
4. **Use descriptive summaries** - keep under 255 characters
5. **Format descriptions clearly** - use markdown when appropriate
6. **Check required fields** - some projects may have custom required fields
7. **Respect workflow** - not all transitions are valid from every status

## Error Handling Example

```python
from jira import JIRA
import subprocess

try:
    token = subprocess.check_output(['pass', 'jira/token']).decode('utf-8').strip()
    jira = JIRA(server='https://issues.apache.org/jira', token_auth=token)
    issue = jira.issue('TIKA-4579')
    print(f"Successfully retrieved: {issue.key}")
except Exception as e:
    print(f"Error: {str(e)}")
```

## Searching for Tickets

```python
from jira import JIRA
import subprocess

token = subprocess.check_output(['pass', 'jira/token']).decode('utf-8').strip()
jira = JIRA(server='https://issues.apache.org/jira', token_auth=token)

# JQL search
issues = jira.search_issues('project=TIKA AND status=Open', maxResults=50)

for issue in issues:
    print(f"{issue.key}: {issue.fields.summary}")
```

## Quick Reference

| Action | Method |
|--------|--------|
| Read ticket | `jira.issue('TIKA-XXXX')` |
| Create ticket | `jira.create_issue(project='TIKA', ...)` |
| Update ticket | `issue.update(field=value)` |
| Add comment | `jira.add_comment(issue, 'text')` |
| Search tickets | `jira.search_issues('JQL query')` |
| Get transitions | `jira.transitions(issue)` |
| Transition ticket | `jira.transition_issue(issue, 'status')` |
