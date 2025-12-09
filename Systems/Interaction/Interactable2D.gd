extends Area2D
class_name Interactable2D
## Base class for any 2D object the player can interact with.
## Example uses: doors, levers, NPCs, pickups, signs, chests, etc.

signal interaction_started(interactor: Node)
## Emitted when an interaction is triggered (e.g. player presses interact)

@export var prompt_text: String = "Press [Y] to interact"
## Text to show in the HUD when the player is in range (optional)

@export var enabled: bool = true
## If false, this interactable will be ignored by the interaction system.


func can_interact(interactor: Node) -> bool:
	## Called before interaction. You can override this in children
	## to add conditions (e.g. needs key, needs item, quest state).
	return enabled


func interact(interactor: Node) -> void:
	## Main entry point for interaction.
	## Default behavior: emit signal. Concrete scenes can connect to it.
	if not can_interact(interactor):
		return
	interaction_started.emit(interactor)
