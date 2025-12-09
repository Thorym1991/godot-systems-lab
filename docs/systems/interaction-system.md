# 🎮 Interaction System

The **Interaction System** provides a simple, reusable foundation for creating objects  
the player can interact with — such as switches, levers, doors, chests, signs, or NPC triggers.

It is designed to be:

- **modular** (works in any project)  
- **generic** (no player-specific logic)  
- **signal-based** (no tight coupling)  
- **minimal** (easy to extend)

This document explains how it works internally and how to build your own interactables.

---

## 📁 Folder Structure

```
Systems/
	Interaction/
		Interactable.gd
		Lever.gd

Demo/
	interaction_demo/
		topdown/
			interaction_TestWorld.tscn
			lever.tscn
			lever.gd
```

---

## 🧩 Core Concept

Every interactable object inherits from **Interactable.gd**.

This script defines:

- how the player detects interaction range  
- how the object responds when the player presses the action button  
- how the object notifies other systems using signals  

This keeps interactions **uniform** and **extensible**.

---

## 🧱 Base Class: `Interactable.gd`

```gdscript
extends Area2D

signal interacted(interactor)

var can_interact: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		can_interact = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		can_interact = false

func try_interact(interactor):
	if not can_interact:
		return
	emit_signal("interacted", interactor)
```

### ⭐ Responsibilities of the base class

- Detect when the player enters/leaves the interaction zone  
- Track whether interaction is currently allowed  
- Expose a single function: `try_interact()`  
- Emit a signal so child scripts can react  
- Does **not** define specific behavior — that happens in child classes

---

## 🔀 Example Child Class: `Lever.gd`

```gdscript
extends Interactable

var is_on := false

func _ready():
	interacted.connect(_on_interacted)

func _on_interacted(interactor):
	is_on = !is_on
	print("Lever toggled! New state: ", is_on)
```

### How it works

- The lever listens to the `interacted` signal  
- When the player presses the action key, `try_interact()` is called  
- The lever toggles its state  
- Other systems may react (doors, lights, logic triggers, etc.)

---

## 🧍 Player Interaction Flow

The player controller (Topdown or Platformer) usually does:

```gdscript
if Input.is_action_just_pressed("interact"):
	if current_interactable:
		current_interactable.try_interact(self)
```

Why this is good architecture:

- Player does **not** need to know the object type  
- Objects do **not** need to know the player script  
- Everything communicates via **signals**  
- Fully decoupled system  

---

## 🧪 Demo Scenes

Located in:

```
Demo/interaction_demo/topdown/
```

Includes:

- `interaction_TestWorld.tscn` — small world  
- `lever.tscn` — interactable object  

The player approaches a lever and presses the button → lever toggles.  
The demo is intentionally simple so you can copy/paste it into your own project.

---

## 🏗 Creating Your Own Interactable

1. Create a new script inheriting from `Interactable.gd`:

```gdscript
extends Interactable
```

2. Connect to the base signal:

```gdscript
func _ready():
	interacted.connect(_on_interacted)
```

3. Define what happens when interaction occurs:

```gdscript
func _on_interacted(interactor):
	print("Object was used!")
```

4. Add an `Area2D + CollisionShape2D`  
→ Defines the interaction radius.

Done!  
You now have a fully functional interactable object.

---

## ✅ Summary

The Interaction System is:

- **simple** → only one base class  
- **powerful** → supports any type of interactable  
- **extensible** → easy to add new objects  
- **decoupled** → uses signals instead of hard references  

Use this system whenever you need clean, reusable interaction logic  
in your Godot projects.
