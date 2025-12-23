extends Carryable2D
class_name CarryableBomb2D

@onready var bomb: RigidBody2D = owner as RigidBody2D

func _ready() -> void:
	if bomb == null:
		push_error("CarryableBomb2D: owner ist kein RigidBody2D.")
		return

func on_pickup(_carrier: Node) -> void:
	if bomb == null: return

	# Bomb2D soll Animation + Timer steuern
	if owner and owner.has_method("arm"):
		owner.call("arm")

	bomb.freeze = true
	bomb.linear_velocity = Vector2.ZERO
	bomb.angular_velocity = 0.0

func on_drop(_carrier: Node) -> void:
	if bomb == null: return
	bomb.freeze = false
	bomb.sleeping = false

func on_throw(_carrier: Node, dir: Vector2, force: float) -> void:
	if bomb == null: return
	bomb.freeze = false
	bomb.sleeping = false
	bomb.angular_velocity = 0.0
	bomb.linear_velocity = dir.normalized() * force

func set_carried_transform(pos: Vector2, offset: Vector2) -> void:
	if bomb == null: return
	bomb.global_position = pos + offset
