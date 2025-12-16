extends Node
class_name StoneInteract

@export var interactable_path: NodePath = NodePath("../InteractableArea")
@export var carryable_path: NodePath = NodePath("../Carryable")

@onready var interactable: Interactable2D = get_node_or_null(interactable_path) as Interactable2D
@onready var carryable: Carryable2D = get_node_or_null(carryable_path) as Carryable2D

func _ready() -> void:
	if interactable == null or carryable == null:
		push_error("StoneInteract: Pfade falsch gesetzt (interactable/carryable).")
		return

	interactable.prompt_text = "Hold Interact to lift"
	interactable.interaction_started.connect(_on_interact)

func _on_interact(interactor: Node) -> void:
	if interactor is TopdownPlayer2D:
		(interactor as TopdownPlayer2D).pickup(carryable)
