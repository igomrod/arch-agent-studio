# Agentic Architecture Studio

This repository is designed for "Agentic Architecture" work using the C4 Model and Structurizr DSL. It provides a local environment for visualizing architecture diagrams and a set of guidelines for AI agents to assist in the process.

## Prerequisites

-   [Docker](https://www.docker.com/)
-   [Make](https://www.gnu.org/software/make/) (optional, but recommended)

## Getting Started

1.  **Start the Server**:
    ```bash
    make up
    # OR
    docker-compose up -d
    ```

2.  **View the Diagrams**:
    Open [http://localhost:8080](http://localhost:8080) in your browser. You should see the "System Context" diagram for the "Software System".

3.  **Stop the Server**:
    ```bash
    make down
    ```

## Managing Projects

This studio supports multiple Structurizr projects.

### Creating a New Project
Use the Antigravity workflow or run manually:
```bash
make init-project NAME=my-new-project
```
This will create a new directory in `projects/` and switch to it.

### Switching Projects
Use the Antigravity workflow or run manually:
```bash
make switch-project NAME=existing-project
```
This will update the `.current_project` file and restart the server.

### Start the Server
```bash
make up
```
This starts Structurizr Lite for the currently selected project (defined in `.current_project`).

## How to Use

### Modifying the Architecture
The architecture is defined in `projects/<current-project>/workspace.dsl`. You can edit this file manually or ask an AI agent to do it for you.

**Example Prompts for AI:**
-   "Add a 'Web Application' container to the Software System."
-   "Create a relationship between the User and the Web Application."
-   "Add a component view for the API Application."

### Hot Reloading
The `structurizr/lite` container is configured to watch for changes in the `workspace` directory. When you save changes to `workspace.dsl`, refresh your browser to see the updates immediately.

### Documentation & ADRs
-   Place Markdown documentation in `workspace/docs/`.
-   Place Architecture Decision Records (ADRs) in `workspace/adrs/`.
-   These will be automatically rendered in the Structurizr UI.

## AI Guidelines
This repository is "Agentic IDE Agnostic". It includes standardized guidelines for various AI coding assistants to ensure consistent behavior when working with the C4 Model and Structurizr DSL.

-   `AI_GUIDELINES.md`: The generic source of truth for all agents.
-   `.cursorrules`: Specific instructions for Cursor.
-   `.windsurfrules`: Specific instructions for Windsurf.
-   `.agent/rules/AI_GUIDELINES.md`: Specific instructions for Antigravity IDE.
-   `.github/copilot-instructions.md`: Specific instructions for GitHub Copilot.

These files ensure that any AI agent understands the hierarchy (Context, Container, Component) and follows best practices.

### Synchronization
To avoid duplication, `AI_GUIDELINES.md` is the single source of truth. If you need to update the guidelines:
1.  Edit `AI_GUIDELINES.md`.
2.  Run `make sync-rules` to propagate changes to the other files.
