# Agentic Architecture Studio

> [!WARNING]
> **🧪 Experimental Project**
> 
> This project is fully experimental and under active development. APIs, workflows, and project structure may change without notice. Use at your own risk.

This repository is designed for **"Agentic Architecture"** work using the C4 Model and Structurizr DSL. It provides a local environment for visualizing architecture diagrams and a set of guidelines for AI agents to assist in the process.

While the principles here are general, this project is currently **optimized and tested for use with [Antigravity](https://www.google.com/search?q=antigravity+ide) agents**. usage with other agents is possible but experimental.

---

## ⚠️ Important Disclaimer

> [!CAUTION]
> **Architecture is a Craft, Not a Task to Delegate**
>
> Designing software systems is a complex discipline that requires years of training, experience, and deep contextual understanding. It involves trade-offs, stakeholder alignment, and decisions that have long-lasting consequences.
>
> **Fully delegating architecture work to AI agents is not advisable.** Agents can assist, accelerate, and automate repetitive diagramming tasks, but they lack the judgment and domain expertise of a seasoned architect.
>
> **This tool is most useful when YOU know what you're doing.** Use it to speed up your workflow, not to replace your thinking.

---

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

---

## Use Cases

Here are some use cases that have been tested with this tool:

### 1. Generate Diagrams from a Text Brief

You can provide an AI agent with a high-level system description (a "brief") and ask it to generate the full C4 model including System Context, Container, Component, and Deployment views.

<details>
<summary><strong>📋 Example: "DroneDrop" Medical Logistics Network</strong></summary>

**Prompt:**

> **System Brief: "DroneDrop" Medical Logistics Network**
>
> **The Problem:**
> In dense urban environments, transporting urgent medical samples (blood, biopsy tissue) between local clinics and central pathology labs is slow and unreliable due to traffic congestion. Delays in transport lead to delays in diagnosis and treatment.
>
> **The Solution:**
> "DroneDrop" is an autonomous aerial logistics platform. It manages a fleet of quadcopter drones that physically fly secure cargo containers between registered medical facilities, bypassing road traffic entirely.
>
> **Key Users:**
> - **Clinical Staff:** Nurses or doctors at clinics who request a pickup and load the drone.
> - **Lab Technicians:** Staff at the destination laboratory who receive the delivery.
> - **Fleet Operator:** A centralized human supervisor who monitors the entire fleet for emergencies and can override autonomous flight paths.
>
> **High-Level Architecture Requirements:**
>
> *The Drone Fleet (IoT Hardware):*
> Each drone is an autonomous physical device. It reports telemetry (GPS, battery, motor health) every second via 4G/5G. It has a smart cargo locker that only opens when authorized.
>
> *DroneDrop Cloud Platform:*
> - **Fleet Control Service:** The core brain. It receives telemetry, calculates flight paths to avoid no-fly zones, and issues commands to drones.
> - **Logistics API:** Manages orders, tracking numbers, and user authentication.
> - **Telemetry Stream:** A high-throughput message broker (like Kafka or RabbitMQ) ingesting the massive stream of sensor data from the drones.
>
> *User Interfaces:*
> - **Clinic Web Portal:** Used by nurses to book flights and track inbound drones.
> - **Operator Command Dashboard:** A desktop application used by the Fleet Operator. It renders a real-time 3D map of all drones and allows manual control overrides.
>
> *External Integrations:*
> - **National Airspace API:** An external government system we must query to file flight plans and check for temporary flight restrictions (TFRs).
> - **Weather Service:** Provides wind speed and precipitation data to ensure safe flying conditions.

**Expected Output:**

The agent will generate a complete `workspace.dsl` file with:
- System Context view showing users and external systems
- Container view detailing the cloud platform components
- Component views for key containers (e.g., Fleet Control Service)
- Deployment views for Production (AWS) and Development (Local Docker)

</details>

### 2. Generate Diagrams from an Image

You can provide an existing architecture diagram (a photo of a whiteboard sketch, a screenshot, or an exported image) and ask the agent to reverse-engineer it into Structurizr DSL.

**Example Prompt:**
> "Here's a photo of our whiteboard architecture. Can you convert this into a C4 model using Structurizr DSL?"

The agent will analyze the image, identify systems, containers, and relationships, and generate the corresponding DSL code.

---

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

---

## How to Use

### Collaborative Modeling with Agents
This repository is intended to be used directly by an AI agent (specifically Antigravity). The agent has access to specific rules (in `.agent/rules/c4modelling.md`) that teach it how to write valid Structurizr DSL and follow the C4 model hierarchy.

**Recommended Workflow:**
1.  **Start:** Initialize a project.
2.  **Brief:** Provide the agent with a high-level description of what you want to model.
3.  **Refine:** Ask the agent to add details, new containers, or specific views.
4.  **Visualize:** The agent edits the Code, and you see the results instantly in the browser.

### Modifying the Architecture
The architecture is defined in `projects/<current-project>/workspace.dsl`. You can edit this file manually, but the power of this studio comes from asking the agent to handle the syntax for you.

**Example Prompts for Antigravity:**
-   "Add a 'Web Application' container to the Software System."
-   "Create a relationship between the User and the Web Application."
-   "Add a component view for the API Application."

### Hot Reloading
The `structurizr/lite` container is configured to watch for changes in the `workspace` directory. When you save changes to `workspace.dsl`, refresh your browser to see the updates immediately.

### Documentation & ADRs
-   Place Markdown documentation in `workspace/docs/`.
-   Place Architecture Decision Records (ADRs) in `workspace/adrs/`.
-   These will be automatically rendered in the Structurizr UI.

---

## AI Guidelines

This repository contains standardized guidelines for AI coding assistants to ensure consistent behavior when working with the C4 Model and Structurizr DSL.

**Tested & Supported:**
-   `.agent/rules/c4modelling.md`: **Antigravity IDE**. These are the primary rules used to guide the agent in this studio.

**Experimental / Legacy:**
-   `.github/copilot-instructions.md`: Instructions for GitHub Copilot. (Not actively verified).

**Note:** Originally designed to be "Agentic IDE Agnostic", this project has evolved to focus on the capabilities of Antigravity agents. Support for other agents is currently not a priority.

---

## License

This project is provided as-is for experimental purposes.
