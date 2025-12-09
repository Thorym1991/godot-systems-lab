# 🔌 Autoloads Overview

This project currently uses **one global autoload**, with more planned for future systems  
(e.g., Inventory, Dialog System, Save/Load).

---

## 📁 Active Autoloads
core/globals/GlobalSignals.gd

---

# 📡 GlobalSignals.gd

The central signal hub of the framework.

`GlobalSignals` provides globally accessible signals that allow systems to communicate  
**without tight coupling**.  
This improves modularity, testability, and maintainability.

### 📍 Path
core/globals/GlobalSignals.gd

---

## 🎯 Purpose

- Prevents direct dependencies between systems  
- Player, UI, DemoHub, Interaction objects, etc. can communicate **without referencing each other**  
- Greatly improves debugging and extensibility  
- Makes the framework scalable for large projects  

---

## 📢 Available Signals

> *(This list grows as the framework expands)*

### Player-related
- `player_died`
- `player_health_changed`
- `player_interacted(interactable)`

### Interaction-related
- `interaction_started`
- `interaction_finished`
- `lever_toggled(new_state)`

### UI-related
- `request_show_message(text)`
- `request_open_menu(menu_name)`
- `back_to_hub_pressed`

### System-related
- `scene_loaded(path)`
- `scene_unloaded(path)`

---

## 📘 How to Use Global Signals

### Emit a signal
```gdscript
GlobalSignals.player_died.emit()
Connect to a signal
GlobalSignals.player_died.connect(_on_player_died)

Example function
func _on_player_died():
	print("Player died — reacting from another system!")

✅ Summary
GlobalSignals.gd is:
simple — one file, globally accessible
powerful — connects all systems cleanly
decoupled — no direct references needed
extendable — add new signals anytime
Use this autoload whenever a system needs to talk to another without creating dependencies.
