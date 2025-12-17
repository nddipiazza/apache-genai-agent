# How to work on Apache JIRA Tickets with an AI Agent

This guide provides a step-by-step workflow for AI agents to effectively work on Apache Software Foundation JIRA tickets, from ticket selection through to pull request creation.

## Overview

The complete workflow for working on Apache JIRA tickets involves:
1. Finding and selecting an appropriate ticket
2. Reading and understanding the ticket requirements
3. Setting up the development environment
4. Implementing the fix or feature
5. Testing the changes
6. Creating a pull request
7. Updating the JIRA ticket with PR information

## Step 1: Finding a Ticket to Work On

### Search for Open Tickets

Use JQL (JIRA Query Language) to find suitable tickets:

```python
from jira import JIRA
import subprocess

token = subprocess.check_output(['pass', 'jira/token']).decode('utf-8').strip()
jira = JIRA(server='https://issues.apache.org/jira', token_auth=token)

# Find unassigned, open tickets in Tika project
issues = jira.search_issues(
    'project=TIKA AND status=Open AND assignee is EMPTY ORDER BY priority DESC, updated DESC',
    maxResults=20
)

for issue in issues:
    print(f"{issue.key}: {issue.fields.summary}")
    print(f"  Priority: {issue.fields.priority.name if issue.fields.priority else 'None'}")
    print(f"  Type: {issue.fields.issuetype.name}")
    print(f"  Updated: {issue.fields.updated}")
    print()
```

### Good Tickets for AI Agents

Look for tickets that are:
- **Well-defined**: Clear description of the problem or feature
- **Scoped appropriately**: Not too large or complex for automated work
- **Have examples**: Include test cases, error messages, or sample files
- **Bug fixes or improvements**: Often more straightforward than new features

## Step 2: Reading the Ticket

### Extract Full Ticket Information

```python
# Get the complete ticket details
issue = jira.issue('TIKA-XXXX')

print(f"Summary: {issue.fields.summary}")
print(f"Description:\n{issue.fields.description}")
print(f"Status: {issue.fields.status.name}")
print(f"Priority: {issue.fields.priority.name if issue.fields.priority else 'None'}")
print(f"Components: {[c.name for c in issue.fields.components]}")
print(f"Labels: {issue.fields.labels}")

# Read all comments for additional context
if issue.fields.comment.comments:
    print("\nComments:")
    for comment in issue.fields.comment.comments:
        print(f"\n[{comment.author.displayName} - {comment.created}]")
        print(comment.body)

# Check for attachments
if issue.fields.attachment:
    print("\nAttachments:")
    for attachment in issue.fields.attachment:
        print(f"- {attachment.filename} ({attachment.size} bytes)")
        print(f"  URL: {attachment.content}")
```

### Analyze the Requirements

Based on the ticket information:
1. Identify what needs to be changed (bug fix, new feature, improvement)
2. Determine which components/modules are affected
3. Note any specific files or classes mentioned
4. Review any error messages or stack traces
5. Check for related tickets mentioned in comments

## Step 3: Setting Up the Development Environment

### Clone the Repository

For Apache Tika (adjust for other Apache projects):

```bash
# Clone the repository if not already done
git clone https://github.com/apache/tika.git
cd tika

# Create a new branch for your work
git checkout -b TIKA-XXXX-description
```

### Build the Project

```bash
# For Maven-based projects like Tika
mvn clean install -DskipTests

# Or to include tests
mvn clean install
```

### Verify the Environment

```bash
# Ensure tests pass before making changes
mvn test

# Or run specific test class
mvn test -Dtest=TestClassName
```

## Step 4: Implementing the Fix or Feature

### Locate the Relevant Files

Use the ticket information to find files that need modification:

```bash
# Search for relevant classes or methods
grep -r "ClassName" --include="*.java"

# Find test files
find . -name "*Test.java" -type f
```

### Make the Changes

1. **Follow Apache coding standards** for the specific project
2. **Keep changes focused** on the ticket requirements
3. **Add comments** explaining complex logic
4. **Update JavaDocs** or documentation as needed
5. **Handle edge cases** mentioned in the ticket

### Example Code Pattern

```java
// Before (bug that needs fixing)
public String parseDocument(InputStream input) {
    // Missing null check - causes NPE
    return parser.parse(input);
}

// After (with fix)
public String parseDocument(InputStream input) {
    if (input == null) {
        throw new IllegalArgumentException("Input stream cannot be null");
    }
    return parser.parse(input);
}
```

## Step 5: Testing the Changes

### Write Unit Tests

Every change should include appropriate tests:

```java
@Test
public void testParseDocumentWithNullInput() {
    assertThrows(IllegalArgumentException.class, () -> {
        parser.parseDocument(null);
    });
}

@Test
public void testParseDocumentWithValidInput() {
    InputStream input = getClass().getResourceAsStream("/test-file.pdf");
    String result = parser.parseDocument(input);
    assertNotNull(result);
    assertTrue(result.contains("expected content"));
}
```

### Run Tests

```bash
# Run all tests
mvn test

# Run specific test class
mvn test -Dtest=YourTestClass

# Run with specific test method
mvn test -Dtest=YourTestClass#testMethod
```

### Verify the Fix

1. Confirm the bug is fixed or feature works as expected
2. Ensure no existing tests are broken
3. Run integration tests if applicable
4. Check for any warnings or deprecations

## Step 6: Creating a Pull Request

### Commit the Changes

```bash
# Stage your changes
git add .

# Commit with a descriptive message
git commit -m "TIKA-XXXX: Brief description of the fix

- Detailed point about what was changed
- Why this change fixes the issue
- Any relevant notes about the implementation"

# Push to your fork
git push origin TIKA-XXXX-description
```

### Create the Pull Request

1. **Navigate to GitHub**: Go to your fork of the Apache project
2. **Create PR**: Click "New Pull Request"
3. **Title**: Use format "TIKA-XXXX: Brief description"
4. **Description**: Include:
   - Link to the JIRA ticket
   - Summary of changes
   - Testing performed
   - Any breaking changes or notes for reviewers

### PR Description Template

```markdown
## JIRA Ticket
https://issues.apache.org/jira/browse/TIKA-XXXX

## Summary
Brief description of what this PR does.

## Changes
- Specific change 1
- Specific change 2
- Added tests for X

## Testing
- All existing tests pass
- Added new tests for the fix
- Manually tested with [specific scenario]

## Review Focus Areas
Please pay special attention to:
- [ ] **Error handling**: New null checks and exception handling in [specific files]
- [ ] **Test coverage**: New test cases cover edge cases A, B, and C
- [ ] **Performance**: Changes to [specific method] may impact performance
- [ ] **Breaking changes**: None expected, but verify backward compatibility
- [ ] **Documentation**: Updated JavaDoc for modified public APIs

## Notes
Any additional context for reviewers.
```

### Request Code Review Using GitHub CLI

After creating the PR, automatically request a code review:

```bash
# Get the PR number (from the output of gh pr create, or query it)
PR_NUMBER=$(gh pr list --head TIKA-XXXX-description --json number -q '.[0].number')

# Add a review request comment with helpful information
gh pr comment $PR_NUMBER --body "## 🔍 Code Review Request

This PR addresses JIRA ticket [TIKA-XXXX](https://issues.apache.org/jira/browse/TIKA-XXXX).

### Key Changes
- Modified \`src/main/java/...\` to fix NPE
- Added comprehensive tests in \`src/test/java/...\`
- Updated documentation

### Review Checklist
- [ ] Code follows project style guidelines
- [ ] All tests pass (\`mvn clean test\`)
- [ ] No new compiler warnings
- [ ] JavaDoc is complete and accurate
- [ ] Edge cases are properly handled
- [ ] No unnecessary dependencies added

### Files to Review
**Critical:**
- \`src/main/java/org/apache/tika/parser/DocumentParser.java\` - Core fix
- \`src/test/java/org/apache/tika/parser/DocumentParserTest.java\` - Test coverage

**Supporting:**
- \`README.md\` - Documentation updates

### Testing Instructions
\`\`\`bash
mvn clean install
mvn test -Dtest=DocumentParserTest
\`\`\`

Please let me know if you have any questions or need clarification on any changes!"

# Optionally request specific reviewers (if you know the team)
# gh pr edit $PR_NUMBER --add-reviewer username1,username2
```

### Alternative: Request Review During PR Creation

You can also add the review information directly when creating the PR:

```bash
# Create PR with comprehensive review information
gh pr create \
  --title "TIKA-XXXX: Brief description of the fix" \
  --body "## JIRA Ticket
https://issues.apache.org/jira/browse/TIKA-XXXX

## Summary
Brief description of what this PR does.

## Changes
- Specific change 1
- Specific change 2
- Added tests for X

## Testing
- All existing tests pass
- Added new tests for the fix
- Manually tested with [specific scenario]

## Review Focus Areas
Please pay special attention to:
- **Error handling**: New null checks in DocumentParser.java
- **Test coverage**: Edge cases for null inputs
- **Performance**: No performance impact expected
- **Breaking changes**: None

## Files to Review
**Critical:**
- \`src/main/java/org/apache/tika/parser/DocumentParser.java\`
- \`src/test/java/org/apache/tika/parser/DocumentParserTest.java\`

## Testing Instructions
\`\`\`bash
mvn clean install
mvn test -Dtest=DocumentParserTest
\`\`\`" \
  --base main \
  --head TIKA-XXXX-description
```

## Step 7: Updating the JIRA Ticket

### Add a Comment with PR Link

```python
from jira import JIRA
import subprocess

token = subprocess.check_output(['pass', 'jira/token']).decode('utf-8').strip()
jira = JIRA(server='https://issues.apache.org/jira', token_auth=token)

issue = jira.issue('TIKA-XXXX')

pr_url = 'https://github.com/apache/tika/pull/XXX'
comment = f"""I've created a pull request to address this issue:

{pr_url}

Changes include:
- [Brief description of changes]
- Added unit tests to verify the fix
- All existing tests pass

Please review when you have a chance."""

jira.add_comment(issue, comment)
```

### Update Ticket Status (if appropriate)

```python
# Check available transitions
transitions = jira.transitions(issue)
for t in transitions:
    print(f"{t['id']}: {t['name']}")

# Transition to "In Progress" or "Patch Available"
jira.transition_issue(issue, 'In Progress')
```

## Common Pitfalls to Avoid

1. **Don't over-scope**: Stick to what the ticket requests
2. **Don't skip tests**: Always include appropriate test coverage
3. **Don't ignore coding standards**: Follow the project's style guide
4. **Don't break existing functionality**: Run all tests before submitting
5. **Don't forget documentation**: Update docs, comments, and JavaDocs
6. **Don't commit unnecessary changes**: Avoid formatting-only changes in unrelated code

## Best Practices

1. **Start small**: Choose simpler tickets when getting started
2. **Read existing code**: Understand the codebase patterns and style
3. **Ask questions**: Add comments on the JIRA ticket if requirements are unclear
4. **Be thorough**: Test edge cases and error conditions
5. **Document well**: Help reviewers understand your changes
6. **Respond to feedback**: Be ready to iterate on your PR based on review comments

## Checklist Before Submitting

- [ ] Ticket requirements fully understood
- [ ] Code changes implemented and follow project standards
- [ ] Unit tests added/updated
- [ ] All tests pass locally
- [ ] Code is properly documented
- [ ] Commit messages are clear and reference the JIRA ticket
- [ ] Pull request created with good description
- [ ] **Code review information added to PR** (review focus areas, critical files, testing instructions)
- [ ] JIRA ticket updated with PR link
- [ ] No unrelated changes included

## Additional Resources

- **JIRA API Documentation**: See `AI_AGENT_JIRA_INSTRUCTIONS.md` for detailed API usage
- **Apache Contribution Guidelines**: Each Apache project has specific guidelines
- **Project Documentation**: Read the project's CONTRIBUTING.md or developer documentation

## Example End-to-End Workflow

```bash
# 1. Find and select a ticket (using Python/JIRA API)

# 2. Clone and setup
git clone https://github.com/apache/tika.git
cd tika
git checkout -b TIKA-4579-fix-npe

# 3. Build and verify
mvn clean install

# 4. Make changes (edit files as needed)

# 5. Test
mvn test

# 6. Commit and push
git add .
git commit -m "TIKA-4579: Fix NPE in document parser

- Added null check for input stream
- Added unit test to verify fix
- Updated JavaDoc with parameter requirements"
git push origin TIKA-4579-fix-npe

# 7. Create PR on GitHub

# 8. Update JIRA (using Python/JIRA API)
```

This workflow provides a solid foundation for AI agents to effectively contribute to Apache Software Foundation projects through JIRA ticket resolution.
