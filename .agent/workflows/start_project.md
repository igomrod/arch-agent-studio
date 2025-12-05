---
description: Start a new Structurizr project
---
1. Ask the user for the name of the new project (e.g., `my-new-system`).
2. Run the following command to initialize the project and switch to it:
   ```bash
   make init-project NAME=<project-name>
   ```
3. Start the Structurizr Lite server for the new project:
   ```bash
   make up
   ```
4. Inform the user that the project is ready at http://localhost:8080.
