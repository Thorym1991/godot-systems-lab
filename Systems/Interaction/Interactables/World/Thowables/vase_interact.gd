extends Node

@export var interactable_path: NodePath
@export var vase_path: NodePath
@export var carryable_path: NodePath = NodePath("../Carryable")
@onready var carryable: Carryable2D = get_node_or_null(carryable_path) as Carryable2D

@onready var interactable: Interactable2D = get_node_or_null(interactable_path) as Interactable2D
@onready var vase: Vase2D = get_node_or_null(vase_path) as Vase2D

func _ready() -> void:
	if interactable == null:
		push_error("VaseInteract: interactable_path zeigt nicht auf Interactable2D")
		return
	if vase == null:
		push_error("VaseInteract: vase_path zeigt nicht auf Vase2D")
		return

	interactable.prompt_text = "Hold Interact to lift"
	interactable.interaction_started.connect(_on_interact)

func _on_interact(interactor: Node) -> void:
	if interactor is TopdownPlayer2D and carryable:
		(interactor as TopdownPlayer2D).pickup(carryable)
