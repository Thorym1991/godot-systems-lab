# Player State System Documentation

The player system is built using a Finite State Machine (FSM).  
Each player has a **StateMachine node**, which controls which *PlayerState* is active.

---

## How it works


- `StateMachine.gd` stores all states and handles transitions.
- `PlayerState.gd` is the base class every state inherits from.
- Each state controls a specific player behavior (Idle, Move, Air, etc.).
- Transitions happen using `machine.change("state_name")`.

---

## Core Files

| File | Purpose |
|---|---|
| `Systems/player_state/StateMachine.gd` | Registers & switches states |
| `Systems/player_state/PlayerState.gd` | Base class for all states |
| `Platformer states` | Ground movement + jump |
| `Topdown states` | 2D directional movement |

---

## State Flow Example (Platformer)

```mermaid
flowchart LR
	Idle -->|move| Move
	Idle -->|jump| Air
	Move -->|stop| Idle
	Move -->|jump| Air
	Air -->|land| Idle
	Air -->|land + input| Move

## How to add a new state

extends PlayerState

func id() -> StringName:
	return &"dash"

func enter(previous):
	character.velocity.x = 400 * sign(previous.character.velocity.x)


---

# 📄 docs/demos.md
> Dokumentiert die Demo-Szenen & Navigation

```markdown
# Demo Scenes Overview

The DemoHub is the main entry point.  
Each demo shows one gameplay system and allows returning to Hub UI.

---

## DemoHub
