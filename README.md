# 🤖 GenAI Development Agent

> An intelligent AI agent that manages software development workflows through knowledge graphs, automated issue creation, and code generation.

---

## 🔐 IMPORTANT: Authentication Setup Required

> **⚠️ CRITICAL:** Before using this agent, you MUST set up authentication for Jira using the `pass` password manager.

### Quick Setup

The agent expects your Jira API token to be stored in `pass` at the following location:

```bash
pass jira/token
```

**Setup Steps:**

1. **Install `pass` (if not already installed):**
   ```bash
   # Ubuntu/Debian
   sudo apt-get install pass
   
   # macOS
   brew install pass
   
   # Fedora/RHEL
   sudo dnf install pass
   ```

2. **Initialize `pass` (first time only):**
   ```bash
   # Generate a GPG key if you don't have one
   gpg --full-generate-key
   
   # Initialize pass with your GPG key ID
   pass init your-gpg-key-id
   ```

3. **Store your Jira API token:**
   ```bash
   # This will prompt you to enter your Jira API token
   pass insert jira/token
   ```

4. **Verify it works:**
   ```bash
   # Should output your token
   pass jira/token
   ```

### Getting Your Jira API Token

1. Log in to your Jira instance
2. Go to **Profile Settings** → **Security** → **API Tokens**
3. Click **Create API Token**
4. Give it a name (e.g., "GenAI Agent")
5. Copy the token and store it using `pass insert jira/token`

### What Happens If Authentication Fails?

If the agent cannot retrieve your Jira token from `pass`:
- ❌ Jira operations will fail
- 📋 Error messages will appear in the agent logs
- 🔍 You'll see errors like: "Command 'pass jira/token' failed"

**Solution:** Follow the setup steps above to configure `pass` with your Jira token.

---

## 📋 Table of Contents

- [🔐 IMPORTANT: Authentication Setup Required](#-important-authentication-setup-required)
- [Overview](#overview)
- [🚨 Loading Context into the Agent](#-loading-context-into-the-agent)
- [Workflows](#workflows)
  - [Building Knowledge Graphs](#1-building-knowledge-graphs)
  - [Creating Feature Requests](#2-creating-feature-requests--changes)
  - [Creating Bug Reports](#3-creating-bug-reports)
  - [Working Jira Tickets](#4-working-jira-tickets)
  - [Review & Merge](#5-review--merge)
- [Prerequisites](#prerequisites)
- [Documentation](#documentation)
- [Example End-to-End Workflow](#-example-end-to-end-workflow)

---

## 🎯 Overview

This GenAI agent helps development teams automate and streamline their workflow by:

- 🗺️ **Building and maintaining knowledge graphs** for applications
- 🎫 **Automating Jira ticket creation** with proper dependencies
- 🔧 **Generating code changes** based on ticket requirements
- ✅ **Following definition of done** and best practices
- 🔄 **Managing the full development lifecycle** from planning to PR

---

## 🚨 Loading Context into the Agent

> **⚠️ IMPORTANT:** Before you can use the agent effectively, you need to load the necessary context files so the agent understands its capabilities and workflows.

### Step 1: Open Your Editor with GitHub Copilot

Make sure you have GitHub Copilot enabled in your IDE (JetBrains, VS Code, etc.).

### Step 2: Load the Agent Instructions

The agent needs to read the instruction files in this repository to understand how to perform its tasks. You have two options:

**Option A: Load All Context Files at Once**

Open all instruction files in your editor or reference them in your chat:

```bash
# In your IDE's Copilot chat, mention these files:
@AI_AGENT_KNOWLEDGE_GRAPH.md
@AI_AGENT_JIRA_INSTRUCTIONS.md
@AI_AGENT_HOW_TO_CREATE_TICKETS.md
@AI_AGENT_HOW_TO_WORK_TICKETS.md
@AI_AGENT_GITHUB_CLI_INSTRUCTIONS.md
```

**Option B: Load Context as Needed**

Alternatively, mention the specific instruction file relevant to your task:

```bash
# For building knowledge graphs:
@AI_AGENT_KNOWLEDGE_GRAPH.md "build the knowledge graph for /home/youruser/source/tika"

# For creating Jira tickets:
@AI_AGENT_HOW_TO_CREATE_TICKETS.md "create tickets for the authentication feature"

# For working on tickets:
@AI_AGENT_HOW_TO_WORK_TICKETS.md "work ticket PROJ-101"
```

### Step 3: Provide Application Context

Depending on your task, you may need to provide context about your application:

**For Knowledge Graph Creation:**
```bash
# Reference the application directory
"build the knowledge graph for /home/youruser/source/tika"
# The agent will scan the directory and analyze the codebase
```

**For Feature/Bug Work:**
```bash
# Reference the knowledge graph repository
@/home/youruser/source/tika-knowledge-graph "We need to add caching layer"
# The agent will use existing documentation to plan changes
```

### Step 4: Reference Existing Knowledge Graphs

Once you have a knowledge graph, always reference it when working on changes:

```bash
# Include knowledge graph in context
@tika-knowledge-graph/README.md 
@tika-knowledge-graph/architecture/overview.md
"work ticket PROJ-205"
```

### Quick Start Example

Here's a complete example of starting a conversation with the agent:

```bash
# Step 1: Load the knowledge graph instructions
@AI_AGENT_KNOWLEDGE_GRAPH.md

# Step 2: Ask the agent to build the knowledge graph
"build the knowledge graph for /home/youruser/source/tika"

# The agent will analyze the codebase and create comprehensive documentation
```

### Context Best Practices

✅ **Do:**
- Load relevant instruction files before giving commands
- Reference the knowledge graph when working on tickets
- Provide specific paths and ticket numbers
- Keep knowledge graph documentation up to date

❌ **Don't:**
- Expect the agent to remember context between sessions
- Skip loading instruction files
- Work on tickets without referencing the knowledge graph
- Forget to update knowledge graph after changes

---

## 🔄 Workflows

### 1. 🗺️ Building Knowledge Graphs

The knowledge graph serves as a living documentation system that describes your application's architecture, components, and relationships.

#### How to Build a Knowledge Graph

**Command:**
```bash
"build the knowledge graph for /home/youruser/source/tika"
```

**What happens:**
1. 📂 The agent analyzes your application codebase at `/home/youruser/source/tika`
2. 🏗️ Creates a `knowledge-graph/` folder in the root of the repository
3. 📝 Generates comprehensive documentation including:
   - Architecture overview
   - Component relationships
   - API endpoints
   - Data models
   - Dependencies
   - Configuration details
4. 💾 Files are ready to be committed to the same Git repository

**Output Structure:**
```
/home/youruser/source/tika/
├── src/
├── pom.xml
├── knowledge-graph/          ← Created here
│   ├── README.md
│   ├── architecture/
│   ├── components/
│   ├── apis/
│   ├── data/
│   ├── dependencies/
│   └── configuration/
└── ... (other project files)
```

---

### 2. 🎫 Creating Feature Requests & Changes

All changes to your application start with updating the knowledge graph first.

#### Workflow

**Step 1: Describe the Change**

Tell the agent about the change you want to make:

```bash
"We need to add user authentication with JWT tokens and role-based access control"
```

**Step 2: Knowledge Graph Update**

The agent will:
- 📊 Analyze the impact on existing components
- 📝 Create a **draft PR against the knowledge graph repository**
- 🗺️ Update architecture and component documentation
- 🔗 Map dependencies and relationships

**Step 3: Review & Approve Knowledge Graph Changes**

- 👥 Team reviews the knowledge graph PR
- 💬 Discuss architectural decisions
- ✅ Approve the changes once everyone agrees

**Step 4: Create Jira Tickets**

Once the knowledge graph PR is approved:

```bash
"Create Jira tickets for the approved knowledge graph changes"
```

The agent will create tickets following these principles:

✅ **Best Practices:**
- ✂️ **Small, focused tickets** - Easy to review and test
- 📋 **Clear definition of done** - Each ticket has acceptance criteria
- 🔗 **Proper dependencies** - Tickets link to dependencies that must be completed first
- 🏷️ **Appropriate labels** - Bug, feature, task, etc.
- 📊 **Effort estimation** - Story points or time estimates

**Example Output:**
```
Created Jira Tickets:
├── PROJ-101: Create JWT authentication service (depends on: none)
├── PROJ-102: Add User model with roles (depends on: PROJ-101)
├── PROJ-103: Implement role-based middleware (depends on: PROJ-102)
└── PROJ-104: Add authentication endpoints (depends on: PROJ-101, PROJ-103)
```

---

### 3. 🐛 Creating Bug Reports

When you have a bug to fix, the agent helps plan and document the fix.

#### Workflow

**Step 1: Start with Jira Number**

```bash
"Work on bug PROJ-205"
```

**Step 2: Agent Analysis**

The agent will:
- 📖 Read the Jira ticket details
- 🔍 Analyze the issue and affected components
- 📋 Create a **plan of action** to fix the bug
- 🧠 Identify root cause and solution approach

**Step 3: Knowledge Graph Update (if applicable)**

If the bug fix requires architectural or design changes:
- 📝 Creates a **draft PR against the knowledge graph repository**
- 📊 Updates component documentation
- ⚠️ Documents the bug and its resolution

**Example Plan:**
```
Bug Analysis for PROJ-205:
- Issue: Race condition in payment processing
- Root Cause: Concurrent access to payment status
- Solution: Add transaction locking mechanism
- Files to modify: PaymentService.java, PaymentRepository.java
- Tests needed: Concurrent payment test cases
- Knowledge Graph Updates: Document thread-safety in payment component
```

---

### 4. 💻 Working Jira Tickets

Once tickets are created, the agent can implement the changes.

#### How to Work a Ticket

**Command:**
```bash
"work ticket PROJ-101"
```

**The Agent Will:**

1. 📖 **Read the ticket** - Understand requirements and acceptance criteria
2. 📚 **Review knowledge graph** - Check architecture and dependencies
3. 🔍 **Analyze codebase** - Identify files to modify
4. ✍️ **Generate code changes** - Implement the feature/fix
5. ✅ **Write tests** - Create unit and integration tests
6. 🏃 **Run tests** - Ensure all tests pass
7. 📝 **Update documentation** - Inline comments and README updates
8. 🔄 **Create PR** - Against the main application repository
9. 👁️ **Request code review** - Add detailed review information to the PR
10. 📊 **Update knowledge graph** - Create PR for knowledge graph updates
11. 🎫 **Update Jira** - Add comments and transition status

**Automated Steps:**
- ✅ Code generation
- ✅ Test creation and execution
- ✅ PR creation with proper description
- ✅ Code review request with review focus areas
- ✅ Knowledge graph synchronization
- ✅ Jira ticket updates

**Code Review Information Included:**
- 🎯 **Review Focus Areas** - Specific items reviewers should pay attention to
- 📁 **Critical Files** - Key files that need careful review
- 🧪 **Testing Instructions** - How to test the changes locally
- ✅ **Review Checklist** - Standard items to verify before approval
- ⚠️ **Potential Concerns** - Performance, breaking changes, etc.

---

### 5. 🔍 Review & Merge

The final step in the workflow is review and integration.

#### Review Process

**What to Review:**

1. 📝 **Application PR** - Code changes, tests, implementation
2. 🗺️ **Knowledge Graph PR** - Documentation updates
3. ✅ **Definition of Done** - All acceptance criteria met
4. 🧪 **Test Coverage** - Adequate tests for changes
5. 📚 **Documentation** - Clear and complete

#### Iteration

If changes are needed:

```bash
"Update PROJ-101 to use bcrypt instead of SHA-256 for password hashing"
```

The agent will:
- 🔄 Update the code
- 🧪 Regenerate tests
- 📝 Update the PR
- 🗺️ Update knowledge graph if needed

#### Merging

**Important:** Remember to merge **BOTH** PRs:

1. ✅ **Knowledge Graph PR** - Merge first to keep documentation in sync
2. ✅ **Application PR** - Merge after knowledge graph is updated

```bash
# Suggested merge order
1. Review and approve knowledge-graph PR
2. Merge knowledge-graph PR
3. Review and approve application PR
4. Merge application PR
5. Verify deployment and close Jira ticket
```

---

## 📦 Prerequisites

Before using this agent, ensure you have:

### 🔐 Required (Critical)

- ✅ **`pass` Password Manager** - MUST be installed and configured with your Jira token at `pass jira/token`
  - See [Authentication Setup](#-important-authentication-setup-required) section above
  - **This is absolutely required for Jira integration to work**
- ✅ **Jira API Token** - Stored in `pass` as described above
- ✅ **GitHub Copilot** - Enabled in your IDE (JetBrains, VS Code, etc.)

### ✅ Required (Standard)

- ✅ **GitHub CLI (`gh`)** - For repository and PR operations
  - Install: https://cli.github.com/
  - Authenticate: `gh auth login`
- ✅ **Git** - For version control
- ✅ **Development Environment** - Set up for your application stack

### Authentication Details

**GitHub Authentication:**
```bash
# Authenticate with GitHub
gh auth login

# Verify authentication
gh auth status
```

**Jira Authentication:**
```bash
# Your Jira token MUST be stored in pass
pass jira/token

# If this command fails, go back to the Authentication Setup section
```

**What Happens If Authentication Fails:**

| Service | Error Location | Solution |
|---------|---------------|----------|
| **Jira** | Agent logs will show `pass jira/token` command failed | Follow [Authentication Setup](#-important-authentication-setup-required) |
| **GitHub** | Agent logs will show `gh` authentication errors | Run `gh auth login` |

**The agent will NOT work without proper authentication setup!**

---

## 📚 Documentation

Detailed documentation for each component:

- 📖 [**Knowledge Graph Guide**](./AI_AGENT_KNOWLEDGE_GRAPH.md) - How knowledge graphs work
- 🎫 [**Jira Integration**](./AI_AGENT_JIRA_INSTRUCTIONS.md) - Jira workflow details
- 🔧 [**Creating Tickets**](./AI_AGENT_HOW_TO_CREATE_TICKETS.md) - Ticket creation guidelines
- 💻 [**Working Tickets**](./AI_AGENT_HOW_TO_WORK_TICKETS.md) - Development workflow
- 🐙 [**GitHub CLI Guide**](./AI_AGENT_GITHUB_CLI_INSTRUCTIONS.md) - GitHub operations

---

## 🎯 Example End-to-End Workflow

Here's a complete example of adding a new feature:

```bash
# 1. Build knowledge graph (one-time setup)
"build the knowledge graph for /home/youruser/source/myapp"

# 2. Describe the feature
"Add email notification system with templates and scheduling"

# 3. Review knowledge graph PR, approve and merge

# 4. Create Jira tickets
"Create Jira tickets for the approved knowledge graph changes"

# Output: PROJ-301, PROJ-302, PROJ-303 created

# 5. Work each ticket
"work ticket PROJ-301"
# Review PR, iterate if needed, approve and merge

"work ticket PROJ-302"
# Review PR, iterate if needed, approve and merge

"work ticket PROJ-303"
# Review PR, iterate if needed, approve and merge

# 6. Done! Feature is complete with full documentation
```

---

## 🤝 Contributing

This is an evolving system. Contributions and improvements are welcome!

---

## 🆘 Support

If you encounter issues:
1. Check the agent logs for authentication or permission errors
2. Review the detailed documentation linked above
3. Ensure all prerequisites are properly configured

---

**Made with ❤️ by developers, for developers**

