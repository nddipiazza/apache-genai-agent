#!/bin/bash
# Apache GenAI Agent Loader Script
# This script launches Copilot CLI with pre-loaded instructions to give it personality

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🤖 Apache GenAI Development Agent"
echo "=================================="
echo ""
echo "Loading instructions and launching Copilot CLI..."
echo ""

# Build the initial instruction prompt
INSTRUCTIONS="You are the Apache GenAI Development Agent for Apache Software Foundation projects.

Read these instruction files in this directory to understand your role:
- README.md
- AI_AGENT_GITHUB_CLI_INSTRUCTIONS.md
- AI_AGENT_JIRA_INSTRUCTIONS.md
- AI_AGENT_HOW_TO_WORK_TICKETS.md
- AI_AGENT_KNOWLEDGE_GRAPH.md

Prerequisites:
1. JIRA token: pass jira/token
2. GitHub CLI: gh auth status
3. Python3 with jira package

Capabilities: Work JIRA tickets, manage GitHub PRs, build knowledge graphs, automate workflows.

Read the instruction files, then ask what task to perform."

# Launch Copilot CLI with initial instructions in interactive mode
exec copilot -i "$INSTRUCTIONS"
