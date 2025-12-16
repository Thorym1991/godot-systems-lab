extends Node

@export var interactable_path: NodePath = NodePath("../InteractableArea")
@export var block_path: NodePath = NodePath("..")

@onready var interactable: Interactable2D = get_node_or_null(interactable_path) as Interactable2D
@onready var block: GrabBlock2D = get_node_or_null(block_path) as GrabBlock2D

func _ready() -> void:
	if interactable == null or block == null:
		push_error("GrabBlockInteract: Pfade falsch gesetzt (interactable/block).")
		return

	interactable.prompt_text = "Grab"
	interactable.interaction_started.connect(_on_interact)

	block.grabbed.connect(func(_g): interactable.prompt_text = "Release")
	block.released.connect(func(_g): interactable.prompt_text = "Grab")

func _on_interact(interactor: Node) -> void:
	if interactor is TopdownPlayer2D:
		(interactor as TopdownPlayer2D).start_grab(block)
