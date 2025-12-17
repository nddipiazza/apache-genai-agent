# AI Agent that can create and maintain Knowledge Graphs that describe applications

## Overview

Each software project has a "knowledge graph" which is a hierarchical set of `.md` files and folders with accompanying information that describes the application's architecture, components, dependencies, and relationships. This knowledge graph serves as a living documentation system that evolves with the codebase.

## Core Responsibilities

### 0. Initial Knowledge Graph Population

The agent must be able to analyze an application from scratch and populate the initial knowledge graph structure.

There is a convention that the knowledge graph is stored along-side the git project in your local as `{absPath}-knowledge-graph`.

So `/home/yourname/source/tika` would have a knowledge-graph folder `/home/yourname/source/tika-knowledge-graph`

This is knowledge graph is a git project so must be initialized as a git repo with a "main" branch when done.

I don't want the agent to create git repos. We should prompt the user to create Git repo and come back with the Git repo url.

#### Steps for Initial Setup:

1. **Project Discovery**
   - Scan the project directory structure
   - Identify the technology stack (languages, frameworks, libraries)
   - Detect project type (web app, API, microservice, monolith, etc.)
   - Identify build systems and dependency management files

2. **Codebase Analysis**
   - Parse source code files to identify:
     - Main entry points
     - Core modules and packages
     - Classes, functions, and their relationships
     - API endpoints and routes
     - Database schemas and models
     - Configuration files
     - External dependencies

3. **Architecture Mapping**
   - Identify architectural patterns (MVC, microservices, layered, etc.)
   - Map component relationships and dependencies
   - Document data flows
   - Identify integration points with external services

4. **Knowledge Graph Structure Creation**
   ```
   knowledge-graph/
   ├── README.md                          # Overview of the application
   ├── architecture/
   │   ├── overview.md                    # High-level architecture
   │   ├── patterns.md                    # Design patterns used
   │   └── diagrams/                      # Architecture diagrams
   ├── components/
   │   ├── component-1/
   │   │   ├── overview.md
   │   │   ├── api.md
   │   │   ├── dependencies.md
   │   │   └── relationships.md
   │   └── component-2/
   │       └── ...
   ├── data/
   │   ├── models.md                      # Data models and schemas
   │   ├── migrations.md                  # Database migrations
   │   └── flows.md                       # Data flow documentation
   ├── apis/
   │   ├── endpoints.md                   # API endpoint catalog
   │   ├── authentication.md              # Auth mechanisms
   │   └── integration.md                 # External API integrations
   ├── dependencies/
   │   ├── internal.md                    # Internal dependencies
   │   ├── external.md                    # External libraries/services
   │   └── version-matrix.md              # Dependency versions
   ├── configuration/
   │   ├── environment.md                 # Environment variables
   │   ├── settings.md                    # Configuration settings
   │   └── deployment.md                  # Deployment configs
   └── changelog/
       └── updates.md                     # Knowledge graph update history
   ```

5. **Initial Documentation Generation**
   - Create markdown files for each identified component
   - Document relationships using cross-references
   - Include code snippets where relevant
   - Add metadata (last updated, version, etc.)

6. **Validation**
   - Ensure all cross-references are valid
   - Verify completeness of documentation
   - Check for orphaned or missing components

### 1. Knowledge Graph Maintenance and Updates

The agent must be intelligent enough to take user input about stories, bugs, features, or changes and update the knowledge graph accordingly.

#### Steps for Maintenance:

1. **Input Analysis**
   - Parse user input (story description, bug report, feature request)
   - Identify affected components
   - Determine scope of changes
   - Extract key entities (files, functions, classes, APIs, etc.)

2. **Impact Assessment**
   - Map the change to existing knowledge graph nodes
   - Identify which documentation files need updates
   - Determine new components or relationships
   - Assess ripple effects on dependent components

3. **Knowledge Graph Updates**
   - **For New Features:**
     - Create new component documentation if needed
     - Update existing component docs with new functionality
     - Add new API endpoints to the catalog
     - Update data models if schema changes
     - Document new dependencies
     - Update architecture docs if pattern changes
   
   - **For Bug Fixes:**
     - Update affected component documentation
     - Clarify behavior or constraints
     - Add notes about edge cases
     - Update known issues/limitations
   
   - **For Refactoring:**
     - Update component relationships
     - Revise architecture documentation
     - Update dependency graphs
     - Reorganize knowledge graph structure if needed

4. **Cross-Reference Maintenance**
   - Update all bi-directional links
   - Add new relationships
   - Remove obsolete references
   - Ensure consistency across all documents

5. **Changelog Documentation**
   - Record what changed in the knowledge graph
   - Link to the triggering story/bug/feature
   - Timestamp the update
   - Track who/what requested the change

6. **Validation and Consistency**
   - Verify all links are valid
   - Check for conflicting information
   - Ensure terminology is consistent
   - Validate against actual codebase

## Agent Capabilities Required

### Technical Skills

1. **Code Analysis**
   - Parse multiple programming languages
   - Understand framework-specific patterns
   - Extract semantic meaning from code
   - Identify design patterns

2. **Documentation Generation**
   - Write clear, concise markdown
   - Create proper cross-references
   - Generate diagrams (Mermaid, PlantUML)
   - Maintain consistent formatting

3. **Relationship Mapping**
   - Build dependency graphs
   - Track component interactions
   - Map data flows
   - Identify integration points

4. **Change Detection**
   - Diff and analyze code changes
   - Understand commit messages
   - Parse issue/ticket descriptions
   - Identify affected components

### Intelligence Requirements

1. **Context Understanding**
   - Comprehend the purpose of changes
   - Understand business logic
   - Recognize architectural implications
   - Anticipate downstream effects

2. **Decision-Making**
   - Determine what needs documentation
   - Decide on appropriate detail level
   - Choose optimal organization structure
   - Prioritize updates

3. **Learning and Adaptation**
   - Learn project-specific terminology
   - Adapt to coding conventions
   - Recognize patterns over time
   - Improve accuracy with feedback

## Workflow Examples

### Example 1: Initial Setup for a Spring Boot Application

```
User Input: "Initialize knowledge graph for this Spring Boot REST API"

Agent Actions:
1. Scan project and identify Spring Boot, Maven, MySQL
2. Create knowledge-graph/ directory structure
3. Parse @RestController classes → generate apis/endpoints.md
4. Parse @Entity classes → generate data/models.md
5. Parse application.yml → generate configuration/settings.md
6. Map @Service dependencies → generate components/*/dependencies.md
7. Create architecture/overview.md with Spring MVC pattern
8. Generate README.md with project summary
```

### Example 2: Feature Addition

```
User Input: "Story: Add user authentication with JWT tokens"

Agent Actions:
1. Identify affected areas: APIs, Security, Data Models
2. Update apis/authentication.md with JWT implementation details
3. Add new component: components/security/jwt-handler.md
4. Update data/models.md with User and Token entities
5. Update apis/endpoints.md with new /auth/* endpoints
6. Update dependencies/external.md with JWT library
7. Add configuration/environment.md entries for JWT secrets
8. Update changelog/updates.md with this feature addition
```

### Example 3: Bug Fix

```
User Input: "Bug: Fix race condition in payment processing"

Agent Actions:
1. Locate components/payment-processor/overview.md
2. Update with clarification on thread-safety
3. Add note about synchronization mechanism
4. Update components/payment-processor/relationships.md with locking strategy
5. Document the edge case in known limitations
6. Record in changelog/updates.md
```

## Best Practices

1. **Keep Documentation Close to Code**
   - Reference actual file paths and line numbers when relevant
   - Include code snippets for clarity
   - Update when code changes

2. **Maintain Bidirectional Links**
   - If A depends on B, document in both places
   - Use consistent linking format
   - Validate links regularly

3. **Use Consistent Terminology**
   - Maintain a glossary
   - Use same names as in code
   - Define domain-specific terms

4. **Version Awareness**
   - Track which version of code is documented
   - Note when documentation lags behind code
   - Include deprecation notices

5. **Progressive Detail**
   - High-level overview at top
   - Drill down into specifics
   - Link to related documents for more info

6. **Automate Where Possible**
   - Generate from code annotations
   - Use static analysis tools
   - Integrate with CI/CD for updates

## Technical Implementation Notes

### Tools and Libraries to Consider

- **Code Parsing**: Tree-sitter, Language Server Protocol
- **Diagram Generation**: Mermaid, PlantUML, Graphviz
- **Markdown Processing**: Remark, Markdown-it
- **Dependency Analysis**: Dependency-cruiser, Madge
- **Knowledge Graph**: Neo4j, NetworkX (for relationship modeling)

### Integration Points

- Version control systems (Git)
- Issue tracking (Jira, GitHub Issues)
- CI/CD pipelines
- Code review systems
- Documentation platforms

### Storage and Format

- Use Git for version control of knowledge graph
- Markdown for human readability
- JSON/YAML metadata files for machine processing
- Symlinks or references for shared concepts

## Future Enhancements

1. **Interactive Visualization**
   - Web-based graph explorer
   - Dynamic relationship diagrams
   - Search and navigation UI

2. **AI-Powered Insights**
   - Suggest refactoring opportunities
   - Identify documentation gaps
   - Predict impact of changes
   - Recommend best practices

3. **Collaboration Features**
   - Multi-user updates
   - Review and approval workflow
   - Comments and annotations
   - Integration with team chat

4. **Metrics and Analytics**
   - Documentation coverage metrics
   - Component complexity scores
   - Dependency health indicators
   - Change frequency tracking

