extends Carryable2D
class_name CarryableStone2D

@export var stone_path: NodePath = NodePath("..")
@export var throw_spawn_distance: float = 16.0

@onready var stone: Stone2D = get_node_or_null(stone_path) as Stone2D

func _ready() -> void:
	if stone == null:
		push_error("CarryableStone2D: stone_path zeigt nicht auf Stone2D.")
		return

func on_pickup(by: Node) -> void:
	if stone == null: return
	stone.enable_physics(false)

func on_drop(by: Node) -> void:
	if stone == null: return
	stone.enable_physics(true)
	stone.linear_velocity = Vector2.ZERO

func on_throw(by: Node, dir: Vector2, force: float) -> void:
	if stone == null: return

	var throw_dir := dir.normalized()
	stone.enable_physics(true)

	# Spawn vor dem Werfer
	if by is Node2D:
		stone.global_position = (by as Node2D).global_position + throw_dir * throw_spawn_distance

	stone.linear_velocity = throw_dir * force

func set_carried_transform(holder_pos: Vector2, carry_offset: Vector2) -> void:
	if stone == null: return
	stone.global_position = holder_pos + carry_offset
