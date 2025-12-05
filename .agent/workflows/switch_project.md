---
description: Switch to an existing Structurizr project
---
1. List the available projects in the `projects/` directory.
   ```bash
   ls projects/
   ```
2. Ask the user which project they want to switch to.
3. Run the following command to switch the context and restart the server:
   ```bash
   make switch-project NAME=<project-name>
   ```
4. Inform the user that the project is active at http://localhost:8080.
