extends Carryable2D
class_name CarryableTorchInterface

@onready var torch := get_parent() as RigidBody2D

func _ready() -> void:
	if torch == null:
		push_error("CarryableTorchInterface: Parent ist kein RigidBody2D.")
		return

func on_pickup(by: Node) -> void:
	torch.freeze = true
	torch.linear_velocity = Vector2.ZERO
	torch.angular_velocity = 0.0

func on_drop(by: Node) -> void:
	torch.freeze = false
	torch.sleeping = false
	torch.linear_velocity = Vector2.ZERO
	torch.angular_velocity = 0.0

func on_throw(by: Node, dir: Vector2, force: float) -> void:
	var throw_dir := dir.normalized()
	torch.freeze = false
	torch.sleeping = false

	if by is Node2D:
		torch.global_position = (by as Node2D).global_position + throw_dir * 24.0

	torch.linear_velocity = throw_dir * force

func set_carried_transform(holder_pos: Vector2, carry_offset: Vector2) -> void:
	torch.global_position = holder_pos + carry_offset
	torch.rotation = 0.0
