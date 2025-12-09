# 🎮 Player State Machine System

The **Player State Machine** is one of the core systems of the Godot Systems Lab.  
It provides a modular, extensible architecture for building player controllers  
(e.g., Platformer, Topdown, 4-way, 8-way, or custom movement types).

This page explains how the system works, how states are structured,  
and how you can extend it for your own projects.

---

# 🧠 1. Overview

The Player State Machine is built around three key components:

1. **StateMachine.gd** – Controls state switching and updates  
2. **PlayerState.gd** – Base class that all states inherit from  
3. Individual Player Controllers:
   - `PlatformerPlayer.gd`
   - `TopdownPlayer2D.gd`

The architecture follows this flow:

```
Player Script → StateMachine → Current State → Player Controller
```

Each state handles a specific part of behavior such as:

- Idle  
- Movement  
- Air / Jumping  
- Dashing (future)  
- Attacking (future)

---

# 🧩 2. Folder Structure

```
Systems/
  player_state/
	StateMachine.gd
	PlayerState.gd

	platformer/
	  PlatformerPlayer.gd
	  states/
		IdleState.gd
		MoveState.gd
		AirState.gd

	topdown/
	  TopdownPlayer2D.gd
	  states/
		TopdownIdle.gd
		TopdownMove.gd
		TopdownMove8way.gd
```

---

# ⚙️ 3. How the System Works

## 🔄 StateMachine.gd

The State Machine script manages:

- entering and exiting states  
- forwarding `_process`, `_physics_process` and input events  
- calling state lifecycle methods  

Main lifecycle functions:

```
enter()      → Called when switching *into* a state
exit()       → Called when leaving a state
update()     → Called every frame (_process)
physics_update() → Called every physics tick
handle_input(event) → Input handling
```

Every state implements these when needed.

---

## 🏷 Example: Basic State Structure

Example `IdleState.gd`:

```gdscript
extends PlayerState

func enter(previous_state):
	player.velocity = Vector2.ZERO
	player.play_animation("idle")

func physics_update(delta):
	if input_movement != Vector2.ZERO:
		state_machine.change_state("MoveState")
```

---

# 🚶‍♂️ 4. Platformer Player States

Platformer states live in:

```
player_state/platformer/states/
```

### Included States

| State | Purpose |
|-------|---------|
| **IdleState** | Player stands still |
| **MoveState** | Walking / running |
| **AirState** | Jumping / falling |

### ⚙️ PlatformerPlayer.gd Responsibilities

- Reads input (jump, move)  
- Applies gravity  
- Moves using `move_and_slide()`  
- Sends player data to states  
- Plays animations via state instructions  

The Player does **not** contain game logic — only movement & physics.  
All gameplay logic lives inside states.

---

# 🧭 5. Topdown Player States

Topdown states live in:

```
player_state/topdown/states/
```

### Included States

| State | Purpose |
|-------|---------|
| **TopdownIdle** | No movement |
| **TopdownMove** | 4-way movement |
| **TopdownMove8way** | Optional diagonal movement |

### ⚙️ TopdownPlayer2D.gd Responsibilities

- Normalized movement vector  
- Movement speed handling  
- Animation changes based on direction  
- Supports both 4-way and 8-way modes  

---

# 🔌 6. How to Add a New State

Adding a new state is easy — follow this template:

```
Systems/player_state/platformer/states/DashState.gd
```

```gdscript
extends PlayerState

func enter(previous):
	player.play_animation("dash")

func physics_update(delta):
	player.velocity = dash_direction * dash_speed
	if dash_finished:
		state_machine.change_state("IdleState")
```

## Steps to register the state:

1. Add the script in the correct folder  
2. Add the state name to the player’s `available_states`  
3. Create animations if needed  
4. Trigger the state via input or condition  

---

# 🔗 7. Communication Between States & Player

Each state automatically has access to:

```
state_machine
player
input_movement
delta
```

States **never** directly talk to other states.  
They always use:

```
state_machine.change_state("StateName")
```

This prevents spaghetti logic and keeps transitions clean.

---

# 🎨 8. Animation Handling

States decide **which animation** the player should play.  
Examples:

```
player.play_animation("walk")
player.play_animation("idle")
player.play_animation("air")
```

This keeps animation logic out of the player controller.

---

# 🏁 9. Summary

The Player State Machine provides:

- Clean state separation  
- Easy extensibility  
- Works for both Platformer and Topdown  
- Centralized animation & logic management  
- No duplicated code between player types  

---

# ➡ Next recommended page:
`interaction-system.md`
