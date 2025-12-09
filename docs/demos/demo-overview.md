# 📊 Demo Overview

The **Godot Systems Lab** includes several demo scenes that showcase how the internal systems work.  
Each demo is designed to be **minimal**, **clean**, and **focused on a single system**.

This page gives you a quick overview of all available demos and where to find them.

---

## 🏠 Demo Hub (`Demo/DemoHub.tscn`)

The **central entry point** for all demos.

**Features:**

- Menu with buttons for every available demo  
- Loads demo scenes additively (no need to close the Hub)  
- Includes the **Back-to-Hub** overlay inside every demo  
- Allows quick testing without restarting the project

**How to use:**

1. Open the scene: `res://Demo/DemoHub.tscn`
2. Press **F6** (Play Scene) or **F5** (Play Project)
3. Click a button to open the corresponding demo

---

## 🎮 Player State System Demos

Located in: `Demo/player_state_demo/`  

These demos show how the shared **Player State System** is used by different controller types.

### 🟦 Platformer Demo

**Path:**  
`Demo/player_state_demo/Platformer/PlayerDemoPF.tscn`  
(uses `TestWorldPF.tscn` as the playground)

**What it demonstrates:**

- Platformer movement (run, jump, fall)  
- Separation of **idle**, **move**, and **air** states  
- How the state machine reacts to input and environment (ground vs. air)  
- A small test world for trying collisions and movement feel

---

### 🟩 Topdown Demo

**Path:**  
`Demo/player_state_demo/Topdown/PlayerDemoTD.tscn`  
(uses `TestWorldTD.tscn` as the playground)

**What it demonstrates:**

- 4-way (and optionally 8-way) topdown movement  
- Using the same state machine core with a different player controller  
- Basic world layout for testing navigation and collision  
- How to plug the Player State System into a topdown game

---

## 🕹 Interaction System Demo

Located in: `Demo/interaction_demo/topdown/`

**Main scenes:**

- World: `Demo/interaction_demo/topdown/interaction_TestWorld.tscn`  
- Lever example: `Demo/interaction_demo/topdown/lever.tscn`  

**What it demonstrates:**

- The `Interactable.gd` base class in action  
- A lever that listens to the `interacted` signal  
- Player pressing the interaction key to toggle the lever  
- How other systems could react to interaction events (e.g., doors, switches, triggers)

The scene is intentionally small so you can easily read the nodes and copy the pattern into your own project.

---

## 📦 Planned / Future Demos

These demos are planned but not implemented yet.  
Their folders may already exist as placeholders:

- `Demo/inventory_demo/` – Inventory and equipment UI  
- Dialogue / NPC interaction demo  
- Combat / ability demo  
- Save & Load showcase

Until these are implemented, any related docs will clearly state that the system is **work in progress**.

---

## ✅ Summary

- Use **DemoHub** to quickly start any demo scene.  
- Use the **Player State demos** to understand movement/state logic (Platformer & Topdown).  
- Use the **Interaction demo** to learn how `Interactable.gd` and signals work.  
- Watch the **future demos** section for upcoming systems like inventory, dialogue, and combat.

For more details on individual demos, continue with:

- `platformer-demo.md`  
- `topdown-demo.md`  
- `interaction-system.md`
