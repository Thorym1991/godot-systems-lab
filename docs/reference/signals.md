# 📡 Global Signals Reference

Global signals are defined in:

``core/globals/GlobalSignals.gd``

They allow different systems to communicate decoupled, without directly knowing each other.

---

## 🧭 Purpose of Global Signals

Global signals help to:

- decouple systems from each other  
- avoid tight connections (e.g., Player → UI → Interaction → Dialog)  
- simplify communication across scenes  
- make testing & extending easier  
- allow systems to broadcast events without caring who listens  

---

# 📑 Available Signals

Below is the list of signals currently implemented in **GlobalSignals.gd**.

---

## 🎮 Player-related Signals

### `player_died`
Emitted when the player dies.

**Usage Example:**
- Respawn system
- UI death screen

---

### `player_health_changed(new_health)`
Emitted whenever the player's health value changes.

Useful for:
- UI health bar
- Damage indicators

---

### `player_interacted(target)`
Emitted when the player performs an interaction (E-Key / Action button).

---

## 🕹 Interaction System Signals

### `interaction_started(target)`
Emitted when the player enters the interaction area of an interactable object.

### `interaction_finished(target)`
Emitted when the player leaves the area.

### `interaction_triggered(target)`
Emitted when the player actually activates the object  
(e.g., lever pulled, chest opened).

Used by:
- doors  
- levers  
- chests  
- switches  

---

## 📦 Inventory System (future signals)

These signals are planned for later framework updates:

### `item_collected(item_id)`
Triggered when the player picks up an inventory item.

### `inventory_updated`
Emitted when the inventory structure changes  
(add / remove / count changed).

---

## 🗺 Scene / Demo Signals

### `demo_changed(demo_name)`
Broadcast when switching between demos from the DemoHub.

### `return_to_hub`
Used when clicking the "Back to Hub" UI button.

---

# 🧪 Example: Connecting to a Global Signal

```gdscript
func _ready():
	GlobalSignals.player_interacted.connect(_on_player_interacted)

func _on_player_interacted(target):
	print("Player interacted with: ", target)

🧠 Summary

Global signals allow:
consistent event architecture
easy extension of new features
systems to remain reusable
zero dependencies between modules
Use them whenever your system needs to notify others without knowing who listens.
