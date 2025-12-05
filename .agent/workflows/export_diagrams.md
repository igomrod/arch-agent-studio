---
description: Export Structurizr diagrams to PNG images in the project folder.
---

1.  **Check Project Status**: Ensure the project is running.
    ```bash
    make logs
    ```
    *(If the container is not running, start it with `make up`)*

2.  **Prepare Output Directory**: Create the export directory for the current project.
    ```bash
    # Determine current project from .current_project file or assume default
    CURRENT_PROJECT=$(cat .current_project 2>/dev/null || echo "projects/awesomestuff")
    mkdir -p "$CURRENT_PROJECT/export"
    echo "Exporting to $CURRENT_PROJECT/export"
    ```

3.  **Run Export**: Execute the make target to export diagrams.
    ```bash
    make export-diagrams
    ```

4.  **Notify User**: Inform the user where the files are located.
