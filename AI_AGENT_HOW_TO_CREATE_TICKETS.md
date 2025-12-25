# How to create Apache JIRA Tickets with an AI Agent

This guide provides a step-by-step workflow for AI agents to create Apache Software Foundation JIRA tickets effectively based on knowledge graph changes and feature requests.

## 🔐 CRITICAL: Authentication Requirement

> **⚠️ IMPORTANT:** All JIRA operations require a valid API token stored in the `pass` password manager.

**The token MUST be accessible via:**
```bash
pass jira/token
```

**If this command fails, JIRA integration will NOT work!**

See the main README's [Authentication Setup section](./README.md#-important-authentication-setup-required) for setup instructions.

---

## Overview

Creating JIRA tickets is a crucial part of the development workflow. This guide covers how to create well-structured tickets that follow Apache best practices, based on:
- Knowledge graph updates (for planned features)
- Bug reports
- Improvement requests
- New feature proposals

## Prerequisites

1. **JIRA API Token Storage** (REQUIRED):
   - ✅ The JIRA API token MUST be stored in `pass` under the key `jira/token`
   - ✅ Retrieve it using: `pass jira/token`
   - ❌ Without this, ticket creation will fail

2. **Python Environment**: Python3 with the `jira` pip package
   - Import using: `from jira import JIRA`

3. **Knowledge Graph**: Have the project's knowledge graph available
   - Located in `knowledge-graphs/<project-name>/`
   - Contains architecture and component documentation

4. **Apache JIRA Access**: Permissions to create tickets in the target project
   - Example: https://issues.apache.org/jira/browse/TIKA

## Ticket Creation Workflow

### Step 1: Analyze the Change Request

Before creating tickets, understand what needs to be done:

1. **Read the Feature Description or Bug Report**
   - What is the user requesting?
   - What problem does it solve?
   - What components are affected?

2. **Review the Knowledge Graph**
   - Check `knowledge-graphs/<project>/architecture/`
   - Identify affected components in `knowledge-graphs/<project>/components/`
   - Review dependencies in `knowledge-graphs/<project>/dependencies/`

3. **Break Down the Work**
   - Identify individual tasks
   - Determine task dependencies
   - Estimate complexity
   - Consider testing requirements

### Step 2: Plan the Ticket Structure

Good ticket planning follows these principles:

#### ✅ Best Practices

1. **Small, Focused Tickets**
   - Each ticket should be completable in 1-3 days
   - Single responsibility - one clear objective
   - Easy to review and test

2. **Clear Dependencies**
   - Use JIRA's "blocks/is blocked by" relationships
   - Create tickets in logical order
   - Ensure foundational work is done first

3. **Comprehensive Descriptions**
   - Clear summary (under 255 characters)
   - Detailed description with context
   - Acceptance criteria
   - Links to knowledge graph documentation

4. **Proper Categorization**
   - Correct issue type (Bug, Improvement, New Feature, Task)
   - Appropriate priority
   - Relevant components
   - Meaningful labels

#### Example Breakdown

For a feature like "Add user authentication with JWT tokens":

```
Epic/Parent Work:
└── PROJ-100: Add user authentication system

Individual Tickets:
├── PROJ-101: Create JWT token service (foundation)
├── PROJ-102: Add User entity and repository (depends on: none)
├── PROJ-103: Implement authentication endpoints (depends on: PROJ-101, PROJ-102)
├── PROJ-104: Add role-based access control middleware (depends on: PROJ-101, PROJ-102)
└── PROJ-105: Create authentication integration tests (depends on: PROJ-103, PROJ-104)
```

### Step 3: Create Tickets Using Python and JIRA API

#### Authentication Pattern

**Every JIRA operation MUST start with this authentication:**

```python
from jira import JIRA
import subprocess

# Get the JIRA API token from pass
token = subprocess.check_output(['pass', 'jira/token']).decode('utf-8').strip()

# Connect to Apache JIRA
jira = JIRA(server='https://issues.apache.org/jira', token_auth=token)
```

#### Creating a Single Ticket

```python
from jira import JIRA
import subprocess

# Authenticate
token = subprocess.check_output(['pass', 'jira/token']).decode('utf-8').strip()
jira = JIRA(server='https://issues.apache.org/jira', token_auth=token)

# Create the ticket
new_issue = jira.create_issue(
    project='TIKA',  # Project key
    summary='Create JWT token service for authentication',
    description='''h2. Overview
This ticket implements a JWT token service to handle token generation, validation, and refresh functionality.

h2. Requirements
* Implement JWTTokenService class
* Support token generation with configurable expiration
* Implement token validation with signature verification
* Add token refresh mechanism
* Include proper error handling for invalid/expired tokens

h2. Acceptance Criteria
* JWTTokenService can generate valid JWT tokens
* Tokens include user ID, roles, and expiration time
* Token validation correctly identifies valid and invalid tokens
* Expired tokens are properly rejected
* Unit tests achieve >90% coverage
* Integration tests verify end-to-end token lifecycle

h2. Technical Details
* Use standard JWT library (e.g., jjwt)
* Store secret in configuration (not hardcoded)
* Use RS256 algorithm for signing
* Token expiration: 1 hour (configurable)
* Refresh token expiration: 7 days (configurable)

h2. Related Documentation
* See knowledge-graph/components/authentication/jwt-service.md
* Architecture: knowledge-graph/architecture/security.md

h2. Testing
* Unit tests for token generation and validation
* Integration tests with mock authentication flow
* Security tests for token tampering
''',
    issuetype={'name': 'New Feature'},
    priority={'name': 'Major'},
    components=[{'name': 'security'}],
    labels=['authentication', 'jwt', 'security']
)

print(f"Created ticket: {new_issue.key}")
print(f"URL: https://issues.apache.org/jira/browse/{new_issue.key}")
```

#### Creating Multiple Related Tickets

```python
from jira import JIRA
import subprocess

# Authenticate
token = subprocess.check_output(['pass', 'jira/token']).decode('utf-8').strip()
jira = JIRA(server='https://issues.apache.org/jira', token_auth=token)

# Define the tickets
tickets = [
    {
        'summary': 'Create JWT token service for authentication',
        'description': '''h2. Overview
Implement JWT token service...

h2. Requirements
* [requirements here]

h2. Acceptance Criteria
* [criteria here]
''',
        'issuetype': 'New Feature',
        'priority': 'Major',
        'components': ['security'],
        'labels': ['authentication', 'jwt'],
        'depends_on': []  # No dependencies
    },
    {
        'summary': 'Add User entity and repository',
        'description': '''h2. Overview
Create User entity with role support...

h2. Requirements
* [requirements here]

h2. Acceptance Criteria
* [criteria here]
''',
        'issuetype': 'New Feature',
        'priority': 'Major',
        'components': ['database'],
        'labels': ['authentication', 'data-model'],
        'depends_on': []  # No dependencies
    },
    {
        'summary': 'Implement authentication endpoints',
        'description': '''h2. Overview
Create REST endpoints for login, logout, and token refresh...

h2. Requirements
* [requirements here]

h2. Acceptance Criteria
* [criteria here]
''',
        'issuetype': 'New Feature',
        'priority': 'Major',
        'components': ['api'],
        'labels': ['authentication', 'api'],
        'depends_on': [0, 1]  # Depends on first two tickets
    }
]

# Create tickets and track them
created_tickets = []

for ticket_def in tickets:
    new_issue = jira.create_issue(
        project='TIKA',
        summary=ticket_def['summary'],
        description=ticket_def['description'],
        issuetype={'name': ticket_def['issuetype']},
        priority={'name': ticket_def['priority']},
        components=[{'name': c} for c in ticket_def['components']],
        labels=ticket_def['labels']
    )
    created_tickets.append(new_issue)
    print(f"Created: {new_issue.key} - {ticket_def['summary']}")

# Add dependencies
for idx, ticket_def in enumerate(tickets):
    if ticket_def['depends_on']:
        for dep_idx in ticket_def['depends_on']:
            # Create "is blocked by" link
            jira.create_issue_link(
                type='Blocks',
                inwardIssue=created_tickets[dep_idx].key,
                outwardIssue=created_tickets[idx].key
            )
            print(f"  {created_tickets[idx].key} is blocked by {created_tickets[dep_idx].key}")

print("\nAll tickets created successfully!")
for ticket in created_tickets:
    print(f"- {ticket.key}: https://issues.apache.org/jira/browse/{ticket.key}")
```

### Step 4: Ticket Description Format

**IMPORTANT:** JIRA uses its own markup format, NOT Markdown!

#### JIRA Markup Reference

```
h1. Heading 1
h2. Heading 2
h3. Heading 3

*bold text*
_italic text_
+underlined+
-strikethrough-
{{monospace}}

* Bullet point 1
* Bullet point 2
** Nested bullet

# Numbered list 1
# Numbered list 2
## Nested number

{code:java}
public class Example {
    // Code block
}
{code}

[Link text|http://example.com]
[PROJ-123] - Link to another ticket

|| Header 1 || Header 2 ||
| Cell 1 | Cell 2 |
| Cell 3 | Cell 4 |
```

#### Template for Feature Tickets

```python
description = '''h2. Overview
[One paragraph describing what this ticket implements]

h2. Requirements
* [Specific requirement 1]
* [Specific requirement 2]
* [Specific requirement 3]

h2. Acceptance Criteria
* [Testable criterion 1]
* [Testable criterion 2]
* [Testable criterion 3]

h2. Technical Details
* [Implementation approach]
* [Technology choices]
* [Key design decisions]

h2. Related Documentation
* See knowledge-graph/components/[component]/[file].md
* Architecture: knowledge-graph/architecture/[file].md

h2. Dependencies
* Depends on: [PROJ-XXX]
* Blocks: [PROJ-YYY]

h2. Testing
* [Test strategy]
* [Coverage requirements]
* [Integration test scenarios]
'''
```

#### Template for Bug Tickets

```python
description = '''h2. Description
[Clear description of the bug]

h2. Steps to Reproduce
# [Step 1]
# [Step 2]
# [Step 3]

h2. Expected Behavior
[What should happen]

h2. Actual Behavior
[What actually happens]

h2. Environment
* Version: [version]
* OS: [operating system]
* Java: [Java version]

h2. Error Messages
{code}
[Stack trace or error message]
{code}

h2. Root Cause
[Analysis of why this happens]

h2. Proposed Solution
* [Solution approach 1]
* [Solution approach 2]

h2. Impact
* Severity: [High/Medium/Low]
* Users affected: [description]
* Workaround: [if available]

h2. Related Documentation
* See knowledge-graph/components/[component]/[file].md
'''
```

### Step 5: Set Proper Metadata

#### Issue Types

Choose the appropriate issue type:

| Type | When to Use |
|------|-------------|
| **Bug** | Fixing broken functionality |
| **New Feature** | Adding completely new functionality |
| **Improvement** | Enhancing existing functionality |
| **Task** | General development task (refactoring, cleanup) |
| **Test** | Adding or improving tests |
| **Documentation** | Documentation updates |

#### Priority Levels

| Priority | When to Use |
|----------|-------------|
| **Blocker** | Completely blocks development or causes data loss |
| **Critical** | Major functionality broken, no workaround |
| **Major** | Important feature broken or missing (default) |
| **Minor** | Small issue with workaround |
| **Trivial** | Cosmetic issue or very minor enhancement |

#### Components

Use project-specific components:

```python
# Example for Apache Tika
components = [
    {'name': 'parser'},      # Parser-related work
    {'name': 'detector'},    # File type detection
    {'name': 'metadata'},    # Metadata extraction
    {'name': 'api'},         # API changes
    {'name': 'security'},    # Security-related
]
```

#### Labels

Use descriptive labels:

```python
labels = [
    'authentication',   # Feature area
    'jwt',             # Technology
    'security',        # Cross-cutting concern
    'api-breaking',    # Breaking change flag
    'performance',     # Performance-related
    'documentation',   # Needs docs update
]
```

### Step 6: Link Tickets Together

#### Dependency Types

```python
# "Ticket A blocks Ticket B" - A must be done before B
jira.create_issue_link(
    type='Blocks',
    inwardIssue='PROJ-101',  # This ticket (A)
    outwardIssue='PROJ-102'  # Is blocked by A
)

# "Ticket B is blocked by Ticket A" - same as above, different direction
jira.create_issue_link(
    type='Blocks',
    inwardIssue='PROJ-101',
    outwardIssue='PROJ-102'
)

# "Ticket A relates to Ticket B" - general relationship
jira.create_issue_link(
    type='Relates',
    inwardIssue='PROJ-101',
    outwardIssue='PROJ-103'
)

# "Ticket B duplicates Ticket A"
jira.create_issue_link(
    type='Duplicate',
    inwardIssue='PROJ-101',  # Original
    outwardIssue='PROJ-104'  # Duplicate
)
```

### Step 7: Validate Ticket Quality

Before finalizing, check that each ticket has:

- [ ] **Clear Summary** - Concise but descriptive (under 255 chars)
- [ ] **Detailed Description** - Enough context for any developer
- [ ] **Acceptance Criteria** - Testable, specific outcomes
- [ ] **Proper Type** - Bug, Feature, Improvement, Task
- [ ] **Appropriate Priority** - Reflects actual urgency
- [ ] **Components** - Tagged with relevant components
- [ ] **Labels** - Descriptive labels for filtering
- [ ] **Dependencies** - Linked to prerequisite tickets
- [ ] **Knowledge Graph Links** - References to documentation
- [ ] **Testing Plan** - How to verify the work

## Complete Example: Creating Tickets for Authentication Feature

```python
#!/usr/bin/env python3
"""
Create JIRA tickets for adding JWT authentication to Apache Tika
"""
from jira import JIRA
import subprocess

# Authenticate
token = subprocess.check_output(['pass', 'jira/token']).decode('utf-8').strip()
jira = JIRA(server='https://issues.apache.org/jira', token_auth=token)

# Define the epic/parent
epic_summary = "Add JWT-based authentication system"

# Define all tickets
ticket_definitions = [
    {
        'summary': 'Create JWT token service',
        'description': '''h2. Overview
Implement a service class to handle JWT token generation, validation, and refresh.

h2. Requirements
* Create JWTTokenService class
* Implement token generation with user claims
* Implement token validation with signature verification
* Add token refresh mechanism
* Support configurable expiration times
* Proper error handling for invalid/expired tokens

h2. Acceptance Criteria
* JWTTokenService successfully generates valid JWT tokens
* Tokens include: user ID, username, roles, issue time, expiration time
* Token validation correctly accepts valid tokens
* Token validation correctly rejects invalid/expired/tampered tokens
* Refresh tokens work with extended expiration
* Unit tests achieve >90% code coverage
* All error cases have appropriate exceptions

h2. Technical Details
* Use standard JWT library (io.jsonwebtoken:jjwt)
* Secret key from configuration (not hardcoded)
* Algorithm: RS256 for signing
* Access token expiration: 1 hour (configurable)
* Refresh token expiration: 7 days (configurable)

h2. Related Documentation
* knowledge-graph/components/authentication/jwt-service.md
* knowledge-graph/architecture/security.md

h2. Testing
* Unit tests for all public methods
* Edge cases: null inputs, expired tokens, invalid signatures
* Performance test: token generation and validation speed
''',
        'type': 'New Feature',
        'priority': 'Major',
        'components': ['security'],
        'labels': ['authentication', 'jwt', 'security'],
        'depends_on': []
    },
    {
        'summary': 'Add User entity with role support',
        'description': '''h2. Overview
Create User entity with support for multiple roles for authentication and authorization.

h2. Requirements
* Create User entity class
* Add fields: id, username, email, password hash, roles, created, updated
* Create UserRepository interface
* Implement database migrations
* Add role enumeration
* Support many-to-many user-role relationship

h2. Acceptance Criteria
* User entity has all required fields
* Password is stored as bcrypt hash (never plaintext)
* Roles are properly mapped (USER, ADMIN, MODERATOR)
* UserRepository supports CRUD operations
* Database schema created via migration
* Unit tests for entity validation
* Integration tests with database

h2. Technical Details
* JPA entity with proper annotations
* BCrypt for password hashing
* Enum for role types
* Liquibase/Flyway for migrations

h2. Related Documentation
* knowledge-graph/data/models.md
* knowledge-graph/components/user-management/user-entity.md

h2. Testing
* Entity validation tests
* Repository integration tests
* Password hashing verification
* Role assignment tests
''',
        'type': 'New Feature',
        'priority': 'Major',
        'components': ['database'],
        'labels': ['authentication', 'data-model', 'database'],
        'depends_on': []
    },
    {
        'summary': 'Implement authentication REST endpoints',
        'description': '''h2. Overview
Create REST endpoints for user authentication: login, logout, token refresh.

h2. Requirements
* POST /api/auth/login - Authenticate user and return tokens
* POST /api/auth/logout - Invalidate refresh token
* POST /api/auth/refresh - Get new access token from refresh token
* POST /api/auth/register - Register new user (optional)
* Proper request/response DTOs
* Error handling and validation

h2. Acceptance Criteria
* Login endpoint accepts username/password, returns access + refresh tokens
* Invalid credentials return 401 Unauthorized
* Logout invalidates refresh token
* Refresh endpoint validates refresh token and returns new access token
* All endpoints have proper error responses (400, 401, 500)
* Input validation on all endpoints
* Integration tests for all endpoints
* API documentation (OpenAPI/Swagger)

h2. Technical Details
* Spring Boot REST controllers
* Request validation using Bean Validation
* Response DTOs: LoginResponse, RefreshResponse
* HTTP Status codes following REST best practices

h2. Related Documentation
* knowledge-graph/apis/endpoints.md
* knowledge-graph/components/authentication/auth-controller.md

h2. Dependencies
* Depends on: JWT token service (PROJ-XXX)
* Depends on: User entity (PROJ-YYY)

h2. Testing
* Integration tests for each endpoint
* Positive and negative test cases
* Input validation tests
* Error handling tests
''',
        'type': 'New Feature',
        'priority': 'Major',
        'components': ['api'],
        'labels': ['authentication', 'api', 'rest'],
        'depends_on': [0, 1]  # Depends on JWT service and User entity
    },
    {
        'summary': 'Add role-based access control middleware',
        'description': '''h2. Overview
Implement middleware/filter to enforce role-based access control on protected endpoints.

h2. Requirements
* Create authentication filter/interceptor
* Validate JWT token on protected endpoints
* Extract user roles from token
* Enforce role-based access rules
* Support @Secured and @RolesAllowed annotations
* Proper error responses for unauthorized access

h2. Acceptance Criteria
* Filter validates JWT token on every protected request
* Invalid/expired tokens return 401 Unauthorized
* Missing required role returns 403 Forbidden
* User roles correctly extracted from token
* Annotation-based security works correctly
* Public endpoints remain accessible
* Integration tests verify access control

h2. Technical Details
* Spring Security Filter or Interceptor
* Token extraction from Authorization header
* Role checking based on annotations
* Integration with Spring Security context

h2. Related Documentation
* knowledge-graph/architecture/security.md
* knowledge-graph/components/authentication/authorization-filter.md

h2. Dependencies
* Depends on: JWT token service (PROJ-XXX)
* Depends on: User entity with roles (PROJ-YYY)

h2. Testing
* Tests for valid tokens with correct roles
* Tests for valid tokens with insufficient roles
* Tests for invalid/expired tokens
* Tests for missing tokens
* Tests for public endpoints
''',
        'type': 'New Feature',
        'priority': 'Major',
        'components': ['security'],
        'labels': ['authentication', 'authorization', 'security'],
        'depends_on': [0, 1]
    },
    {
        'summary': 'Create authentication integration tests',
        'description': '''h2. Overview
Comprehensive integration tests for the complete authentication flow.

h2. Requirements
* End-to-end login flow test
* Token refresh flow test
* Logout flow test
* Access control integration tests
* Multiple user scenarios
* Concurrent authentication tests
* Performance baseline tests

h2. Acceptance Criteria
* Tests cover happy path and error scenarios
* Tests verify complete authentication lifecycle
* Tests check role-based access control
* Tests verify token expiration handling
* All tests pass consistently
* Test coverage >85% for auth components
* Tests run in CI/CD pipeline

h2. Technical Details
* Spring Boot Test with @SpringBootTest
* MockMvc for endpoint testing
* Test data setup and teardown
* Concurrent test scenarios with threads

h2. Related Documentation
* knowledge-graph/testing/integration-tests.md

h2. Dependencies
* Depends on: All previous authentication tickets

h2. Testing
* This ticket IS the testing :)
''',
        'type': 'Test',
        'priority': 'Major',
        'components': ['test'],
        'labels': ['authentication', 'integration-test', 'testing'],
        'depends_on': [0, 1, 2, 3]
    }
]

# Create all tickets
created_tickets = []
print("Creating JIRA tickets...\n")

for idx, ticket_def in enumerate(ticket_definitions):
    new_issue = jira.create_issue(
        project='TIKA',
        summary=ticket_def['summary'],
        description=ticket_def['description'],
        issuetype={'name': ticket_def['type']},
        priority={'name': ticket_def['priority']},
        components=[{'name': c} for c in ticket_def['components']],
        labels=ticket_def['labels']
    )
    created_tickets.append(new_issue)
    print(f"✅ Created: {new_issue.key} - {ticket_def['summary']}")

# Create dependencies
print("\nCreating dependencies...\n")
for idx, ticket_def in enumerate(ticket_definitions):
    if ticket_def['depends_on']:
        for dep_idx in ticket_def['depends_on']:
            jira.create_issue_link(
                type='Blocks',
                inwardIssue=created_tickets[dep_idx].key,
                outwardIssue=created_tickets[idx].key
            )
            print(f"🔗 {created_tickets[idx].key} blocked by {created_tickets[dep_idx].key}")

# Print summary
print("\n" + "="*60)
print("SUCCESS! Created tickets for authentication feature")
print("="*60)
print("\nTickets created:")
for ticket in created_tickets:
    print(f"  • {ticket.key}: {ticket.fields.summary}")
    print(f"    {jira.server}/browse/{ticket.key}")

print("\nSuggested work order:")
for idx, ticket in enumerate(created_tickets, 1):
    print(f"  {idx}. {ticket.key}")
```

## Best Practices Summary

### Do's ✅

1. **Plan Before Creating**
   - Review knowledge graph
   - Break work into logical units
   - Identify dependencies

2. **Write Clear Descriptions**
   - Use JIRA markup (not Markdown)
   - Include context and rationale
   - Add acceptance criteria
   - Link to documentation

3. **Set Proper Metadata**
   - Correct issue type
   - Appropriate priority
   - Relevant components
   - Descriptive labels

4. **Create Dependencies**
   - Link related tickets
   - Use "blocks/is blocked by"
   - Ensure logical work order

5. **Keep Tickets Focused**
   - One clear objective
   - Completable in 1-3 days
   - Easy to review and test

### Don'ts ❌

1. **Don't Create Huge Tickets**
   - Avoid tickets that take weeks
   - Break large work into smaller pieces
   - Each ticket should be independently reviewable

2. **Don't Use Markdown**
   - JIRA uses its own markup
   - h2. for headers, * for bullets
   - {code} for code blocks

3. **Don't Skip Acceptance Criteria**
   - Always define how to verify completion
   - Make criteria testable
   - Be specific and measurable

4. **Don't Ignore Dependencies**
   - Always link dependent tickets
   - Ensure work order makes sense
   - Consider technical prerequisites

5. **Don't Forget the Knowledge Graph**
   - Reference relevant documentation
   - Update knowledge graph when work is done
   - Keep documentation in sync

## Troubleshooting

### Authentication Errors

```python
# Error: "Command 'pass jira/token' failed"
# Solution: Set up pass with your JIRA token
# See: README.md#authentication-setup
```

### Permission Errors

```python
# Error: "You do not have permission to create issues"
# Solution: Ensure you have creator role in the project
# Contact project admin to grant permissions
```

### Invalid Field Errors

```python
# Error: "Field 'components' is not valid"
# Solution: Check project settings for valid components
components = [comp.name for comp in jira.project_components('TIKA')]
print(components)
```

## Reference

### JIRA API Methods

| Method | Purpose |
|--------|---------|
| `jira.create_issue()` | Create a new ticket |
| `jira.create_issue_link()` | Link two tickets |
| `jira.add_comment()` | Add comment to ticket |
| `jira.project_components()` | Get valid components |
| `jira.issue_type_by_name()` | Get issue type info |

### Common JIRA Query Examples

```python
# Find existing tickets for a component
issues = jira.search_issues('project=TIKA AND component=security')

# Find tickets with specific label
issues = jira.search_issues('project=TIKA AND labels=authentication')

# Find unassigned tickets
issues = jira.search_issues('project=TIKA AND assignee is EMPTY')
```

## Summary

Creating good JIRA tickets is essential for successful development:

1. 📋 **Plan thoroughly** using the knowledge graph
2. ✂️ **Break work into small tickets** (1-3 days each)
3. 📝 **Write clear descriptions** with acceptance criteria
4. 🔗 **Link dependencies** properly
5. 🏷️ **Use correct metadata** (type, priority, components, labels)
6. ✅ **Validate quality** before creating

Following these practices ensures tickets are actionable, reviewable, and contribute to a smooth development workflow.
