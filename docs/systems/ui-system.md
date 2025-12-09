# 🖥 UI System Overview

The **UI System** in the Godot Systems Lab provides simple, reusable components
that are used across demos — primarily the **DemoBackHUD**, a small overlay
that allows returning to the Demo Hub without restarting the entire project.

This system is intentionally minimal so it can be replaced or extended in real games.


---

## 📂 Folder Structure
Systems/
	ui/
		DemoBackHUD.tscn
		DemoBackHUD.gd
		
---

## 🎯 Purpose of the UI System

The UI layer handles lightweight UI logic such as:

- A **Back to Hub** button shown inside every demo  
- Displaying contextual UI elements (future modules: prompts, inventory, dialogue)
- Providing a simple place to extend UI functionality later

The goal is to keep UI:
- modular  
- non-intrusive  
- easy to override per demo  

---

## 🧩 DemoBackHUD.tscn

This UI scene is loaded additively on top of every demo.

### Features:
- Floating button anchored to the corner of the screen  
- Calls back to the Demo Hub when pressed  
- Does **not** interact with gameplay logic  

### Script Path:

Demo/DemoBackHUD.gd
---

## 📜 DemoBackHUD.gd — Script Overview

This script handles:

- Loading the DemoHub scene when the button is pressed  
- Optional fade-out or animation hooks  
- Decoupled communication (no tight references to gameplay objects)

### Example Logic (simplified)

```gdscript
func _on_back_pressed():
	get_tree().change_scene_to_file("res://Demo/DemoHub.tscn")
This keeps the UI self-contained and easy to swap out.

🔧 How the UI Is Used in Demos
Inside each demo’s main scene, the DemoBackHUD is loaded via:
	var hud = load("res://Systems/ui/DemoBackHUD.tscn").instantiate()
add_child(hud)
This makes all demos consistent and easy to navigate.

🚧 Future Plans

The UI system will grow over time, with planned modules such as:
Interaction prompts (Press E to interact)
Health bars / stamina UI
Inventory and equipment UI
Dialogue windows
Notification system (floating messages)
All UI additions will follow the same philosophy:
modular, reusable, and decoupled.

✅ Summary
The current UI system includes:
✔ DemoBackHUD (Back to Hub button)
✔ Consistent UI loading pattern for all demos
Future expansions will integrate fully into the Systems folder and follow clean separation of concerns.
