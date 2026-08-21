# System Survivor

### A System Design Survival Game — built entirely in Scilab GUI

Submission for the **Scilab GUIVerse Hackathon** (FOSSEE, IIT Bombay)

---

## Project Description

**System Survivor** is a turn-based simulation game that teaches system design and scalability concepts through direct, consequence-driven play — inspired by the operational lessons in *The Accidental CTO*.

The player runs a live web service starting from a single App Server. Each turn, traffic changes — organic growth, or a random spike event with a short narrative reason ("A blog post about your app went viral," "A marketing campaign drove a surge of new users"). Underlying **workload scenarios** (read-heavy, write-heavy, static-content-heavy) also rotate through the game, changing *which* part of the architecture is under the most pressure. The player must react by spending a limited budget on architectural upgrades — App Servers, a Load Balancer, a Cache layer, DB Read Replicas, a CDN, or Database Sharding — before advancing to the next turn.

Every decision is visualized live: the **Architecture panel** redraws the actual request-flow diagram after every action, coloring each component green/amber/red based on its real-time utilization, so the player can see *exactly* where pressure is building before the system fails.

If System Health reaches 0, the run ends with an **Incident Debrief** — a diagnosis of the specific architectural gap that caused the failure (e.g. "Database write bottleneck," "Static-content traffic reached the app tier"), paired with a real external reference (AWS, MongoDB, Redis, or Cloudflare documentation) so the lesson extends beyond the game itself. Surviving 15 turns without the system going down is a win.

The goal is to compress the kind of hard-won operational intuition described in *The Accidental CTO* — which normally takes years of real incidents to build — into a short, replayable, visual simulation.

---

## Software Requirements

| Requirement | Details |
|---|---|
| Scilab | Version 6.x or later (developed and tested on **Scilab 2026.0.0**) |
| Operating System | Linux, Windows, or macOS (cross-platform — no OS-specific code paths except the optional "Learn More" URL opener, which auto-detects the platform) |
| Additional software | None — no external libraries, no internet connection required to play |

## Toolboxes Used

**None.** System Survivor is built entirely with **base Scilab** — no ATOMS modules or external toolboxes are required. It relies exclusively on:
- Scilab's native **GUI widget set** (`uicontrol`, figures, `findobj`) — originally scaffolded with **GUI Builder** and then extended by hand for dynamic behavior
- Scilab's native **2D graphics primitives** (`xrect`, `xpoly`, `xfpoly`, `xstring`, `newaxes`, `addcolor`, `drawlater`/`drawnow`) for the live architecture diagram
- Core Scilab language features (`struct`, control flow, string handling) for all simulation logic

This was a deliberate constraint, in line with the hackathon's focus on learning Scilab's own GUI capabilities rather than leaning on external tooling.

---

## Steps to Run the Application

1. Ensure Scilab (6.x+) is installed and can be launched from a console.
2. Download or clone the `system-survivor/` project folder, preserving its internal structure (`gui/`, `logic/`, `main.sce`).
3. Open Scilab and set the **current working directory** to the `system-survivor/` project root (via the File Browser panel, or `cd('path/to/system-survivor')` in the console).
4. In the Scilab console, run:
   ```scilab
   exec('main.sce');
   ```
5. The **Main Menu** window will appear. Click **Start Game** to begin.

No build step, compilation, or additional configuration is needed — `main.sce` loads every logic module and GUI screen in the correct order and launches the game directly.

---

## Brief Explanation of the GUI and Its Features

The application has **three screens**, all built on Scilab's dark-themed `uicontrol` widget set:

### 1. Main Menu
A simple entry screen with **Start Game**, **How to Play** (opens a rules summary via `messagebox`), and **Quit**.

### 2. Game Screen — the main dashboard
Divided into four zones inside a single figure:

- **A. Architecture (top-left):** A blank Scilab `axes` object that is *fully redrawn every turn* using graphics primitives. It renders the live request-flow diagram — Users → CDN → Load Balancer → App Server(s) → Cache → Primary Database → Replicas — with:
  - Per-component **RPS and utilization percentage** labeled directly on each box
  - **Color-coded status** (blue = idle, green = healthy, amber = warning, red = critical/overloaded) driven by a dedicated telemetry engine that models real request distribution (e.g., traffic concentrating on a single server when no Load Balancer exists, read/write split across replicas, cache hit-rate offload, CDN static-content offload)
  - Directional arrows showing actual request flow between components, with per-arrow RPS labels
  - A live "highest pressure" callout showing which single component is closest to failing

- **B. Metrics:** Current RPS, total system Capacity, Request Latency, Error Rate, System Health (color-shifts red/amber/green), Budget, Turn counter, and a "Highest Pressure" readout naming the most stressed component and its utilization.

- **C. Event Log:** A scrolling `listbox` that appends a new entry every turn — traffic changes, workload-scenario shifts (e.g. "Workload profile: Read-heavy workload"), saturation alerts naming the specific overloaded component, and confirmations of every purchase — building a full readable history of the playthrough.

- **D. Actions:** Six upgrade buttons (Add App Server, Add Cache, Add DB Replica, Enable Load Balancer, Add CDN, Shard Database), each with its cost shown inline and budget-checked before purchase, plus the large **Next Turn** button that drives the simulation forward.

### 3. End Screen — Result & Incident Debrief
Shows **SYSTEM DOWN** or **YOU SCALED SUCCESSFULLY**, a summary panel (turns survived, peak RPS handled, final architecture, key mistake), and an **Incident Debrief** section that diagnoses the *specific* root cause of failure (e.g. app-server traffic concentration, database write bottleneck, cache-less read pressure) with a plain-language lesson and a **Learn More** button linking to real external documentation (AWS, MongoDB, Redis, or Cloudflare) via a cross-platform URL opener. **Play Again** and **Main Menu** buttons let the player restart or return.

### Key engineering pattern
All widgets are looked up by `Tag` via `findobj`, and each screen's builder function stores its figure handle in a `global` variable (`MENU_FIG`, `GAME_FIG`, `END_FIG`). This lets the simulation's logic modules — which run independently of any single screen's local scope — update any widget on any screen at any time, keeping the GUI-Builder-generated layout code fully decoupled from the simulation logic.

---

## References

- *The Accidental CTO* — conceptual inspiration for the turn-based "learn by breaking things" survival format
- [AWS — How Elastic Load Balancing Works](https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/how-elastic-load-balancing-works.html)
- [AWS RDS — Working with Read Replicas](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html)
- [MongoDB — Sharding](https://www.mongodb.com/docs/manual/sharding)
- [Redis — Client-Side Caching](https://redis.io/docs/latest/develop/clients/client-side-caching/)
- [Cloudflare — What Is a CDN?](https://www.cloudflare.com/learning/cdn/what-is-a-cdn/)
- [Scilab Help — uicontrol](https://help.scilab.org/docs/current/en_US/uicontrol.html)
- [Scilab Help — Graphics primitives (xrect, xpoly, xstring)](https://help.scilab.org/docs/current/en_US/graphics.html)
- Scilab GUI Builder tool (used to scaffold the initial layout for all three screens)

---

*Built for the Scilab GUIVerse Hackathon — an initiative of the FOSSEE Project, IIT Bombay.*