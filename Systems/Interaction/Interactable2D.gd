extends Area2D
class_name Interactable2D

signal interacted(actor: Node)

@export var action_name: StringName = &"Ineract"
@export var interaction_priority: int = 0

func _interacted(actor: Node) -> void:
	interacted.emit(actor)
