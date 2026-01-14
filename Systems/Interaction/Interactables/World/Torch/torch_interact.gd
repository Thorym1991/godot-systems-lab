extends Interactable2D
class_name TorchInteract

@onready var carryable: Carryable2D = get_parent().get_node_or_null("Carryable") as Carryable2D

func _ready() -> void:
	if carryable == null:
		push_error("TorchInteract: Child 'Carryable' nicht gefunden oder falscher Typ (muss Carryable2D sein).")

func interact(interactor: Node) -> void:
	if interactor and carryable and interactor.has_method("pickup"):
		interactor.pickup(carryable)
