# 🧾 Naming Conventions

This document describes the naming conventions used in the **Godot Systems Lab** project.  
The goal is to keep scripts, scenes, and signals **predictable**, **consistent**, and **easy to search**.

These are conventions, not hard rules – but following them will make it much easier to understand
and extend the framework.

---

## 1. General Rules

- Use **lower_snake_case** for:
  - Folders inside `res://`
  - Scene filenames (`.tscn`)
  - Script filenames (`.gd`)
  - Variables and functions
- Use **UpperCamelCase** for:
  - Class names (`class_name` or inner classes)
- Avoid abbreviations unless they are very clear (`HUD`, `UI`, `PF` for platformer, `TD` for topdown).

---

## 2. Files & Folders

Project-level structure:

	res://
		core/
		Systems/
		Demo/
		Assets/
		docs/

System folders:

- `Systems/player_state/`
- `Systems/Interaction/`
- `Systems/inventory/` (planned)
- `Systems/ui/`

Demo folders:

- `Demo/player_state_demo/`
- `Demo/interaction_demo/`
- `Demo/inventory_demo/` (planned)

Scenes should describe **what they are**, not how they look.  
Example:

- `DemoHub.tscn` – main hub scene  
- `TestWorldPF.tscn` – platformer test world  
- `interaction_TestWorld.tscn` – interaction test map  

---

## 3. Player State System Naming

### 3.1 State Machine & Base Types

Scripts:

- `StateMachine.gd` – generic state machine
- `PlayerState.gd` – base class for all player-related states

State scripts use the suffix **`State`** where it makes sense, or a clear, short name:

Platformer:

	Systems/player_state/platformer/
		PlatformerPlayer.gd
		states/
			IdleState.gd
			MoveState.gd
			AirState.gd

Topdown:

	Systems/player_state/topdown/
		TopdownPlayer2D.gd
		states/
			TopdownIdle.gd
			TopdownMove.gd
			TopdownMove8way.gd

Class names:

- `class_name PlatformerPlayer`
- `class_name IdleState`
- `class_name TopdownMove`

Guidelines:

- State names should answer: **“What is the player doing?”**
  - `IdleState`, `MoveState`, `AirState`, `AttackState`, etc.
- Player scripts are named after the **movement style**:
  - `PlatformerPlayer.gd`, `TopdownPlayer2D.gd`

---

## 4. Interaction System Naming

The Interaction System lives here:

	Systems/Interaction/
		Interactable.gd
		Lever.gd

Demo scenes:

	Demo/interaction_demo/topdown/
		interaction_TestWorld.tscn
		lever.tscn
		lever.gd

### 4.1 Base Class

Base script:

- `Interactable.gd` – all interactable objects inherit from this

Class name:

- `class_name Interactable`

Responsibilities:

- Detect when the player enters/leaves interaction range
- Track if interaction is currently allowed
- Expose a single function `try_interact(interactor)`
- Emit a signal when interaction happens

### 4.2 Example Interactables

Scripts:

- `Lever.gd`
- Later: `Door.gd`, `Chest.gd`, `Npc.gd`, etc.

Scenes:

- `lever.tscn`
- `door.tscn`
- `chest.tscn`

Naming pattern:

- **Script:** `Thing.gd`
- **Scene:** `thing.tscn`

So script + scene are easy to pair when searching.

---

## 5. Interaction System Signals

Signals should be **clear verbs** and describe what happened.

Base signals (example):

	signal interaction_started
	signal interaction_finished

Custom object-specific signals:

	signal lever_toggled(new_state)

Guidelines:

- Use **past tense** for completed events:
  - `interaction_finished`, `door_opened`, `chest_opened`
- Use **descriptive names** with arguments when needed:
  - `lever_toggled(new_state: bool)`

---

## 6. Export Variables

Exported variables should describe what they control and be readable in the editor.

Examples for the Interaction System:

	@export var is_active := false
	@export var prompt_text := "Press E to interact"

Guidelines:

- Booleans: prefix with **`is_`**, `can_`, or `has_`
  - `is_active`, `can_repeat`, `has_loot`
- Text shown to the player:
  - `prompt_text`, `label_text`, `message`

---

## 7. Autoloads & Singletons (Short Overview)

Full details are in `autoloads.md`, but for naming consistency:

- Global autoloads use **UpperCamelCase**:
  - `GlobalSignals.gd` → `GlobalSignals`
- They live in:

	core/globals/
		GlobalSignals.gd

- Signals from globals follow the same pattern:
  - `scene_changed(target_scene)`
  - `player_died()`

---

## 8. Summary

- Use **lower_snake_case** for files, folders, variables, and functions
- Use **UpperCamelCase** for classes, autoloads, and main systems
- States end with `State` or have clear action names (`Idle`, `Move`, `Attack`)
- Interactables inherit from `Interactable.gd` and are named by what they represent (`Lever`, `Door`, `Chest`)
- Signals describe **what happened**, often in past tense
- Export variables are descriptive and use prefixes like `is_`, `can_`, `has_`

Following these conventions keeps the **Godot Systems Lab** consistent and easier to maintain as more systems are added.
