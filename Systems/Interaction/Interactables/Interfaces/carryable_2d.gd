extends Node
class_name Carryable2D
## "Interface-like" base class for objects that can be carried/thrown.

func on_pickup(by: Node) -> void:
	pass

func on_drop(by: Node) -> void:
	pass

func on_throw(by: Node, dir: Vector2, force: float) -> void:
	pass

func set_carried_transform(holder_pos: Vector2, carry_offset: Vector2) -> void:
	pass
