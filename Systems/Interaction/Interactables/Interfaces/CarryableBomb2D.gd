extends Carryable2D
class_name CarryableBomb2D

@onready var bomb := owner as RigidBody2D

func on_pickup(_carrier: Node) -> void:
	# Bomb2D soll Animation + Timer steuern
	if owner and owner.has_method("arm"):
		owner.call("arm")

	bomb.freeze = true
	bomb.linear_velocity = Vector2.ZERO

func on_drop(_carrier: Node) -> void:
	bomb.freeze = false

func on_throw(_carrier: Node, dir: Vector2, force: float) -> void:
	bomb.freeze = false
	bomb.linear_velocity = dir * force

func set_carried_transform(pos: Vector2, offset: Vector2) -> void:
	bomb.global_position = pos + offset
