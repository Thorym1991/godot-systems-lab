extends Node
class_name BombInteract

@export var interactable_path: NodePath = NodePath("../Interactable2D")
@export var carryable_path: NodePath = NodePath("../Carryable")

@onready var interactable: Interactable2D = get_node_or_null(interactable_path) as Interactable2D
@onready var carryable: Carryable2D = get_node_or_null(carryable_path) as Carryable2D

func _ready() -> void:
	print("carryable node =", carryable)

	if interactable == null:
		push_error("BombInteract: interactable_path falsch.")
		return
	if carryable == null:
		push_error("BombInteract: carryable_path falsch (heißt der Node wirklich 'Carryable'?).")
		return

	interactable.interaction_started.connect(_on_interact)
	interactable.prompt_text = "Hold Interact to pick up"

func _on_interact(interactor: Node) -> void:
	if interactor is TopdownPlayer2D:
		(interactor as TopdownPlayer2D).pickup(carryable) # ✅
