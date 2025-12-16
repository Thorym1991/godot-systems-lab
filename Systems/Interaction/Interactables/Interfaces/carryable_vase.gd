extends Carryable2D
class_name CarryableVase2D

@export var vase_path: NodePath = NodePath("..")
@export var hit_arm_delay: float = 0.08
@export var throw_spawn_distance: float = 24.0

@onready var vase: Vase2D = get_node_or_null(vase_path) as Vase2D

var _arming_running := false

func _ready() -> void:
	if vase == null:
		push_error("CarryableVase2D: vase_path zeigt nicht auf Vase2D.")
		return

func on_pickup(by: Node) -> void:
	if vase == null: return
	vase.enable_physics(false)
	vase.arm_hitbox(false)

func on_drop(by: Node) -> void:
	if vase == null: return
	vase.enable_physics(true)
	vase.arm_hitbox(false)
	vase.linear_velocity = Vector2.ZERO

func on_throw(by: Node, dir: Vector2, force: float) -> void:
	if vase == null: return

	var throw_dir := dir.normalized()
	vase.enable_physics(true)
	vase.arm_hitbox(false)

	# Spawn vor dem Werfer (falls by ein Node2D ist)
	if by is Node2D:
		vase.global_position = (by as Node2D).global_position + throw_dir * throw_spawn_distance

	vase.linear_velocity = throw_dir * force

	_arm_hitbox_later(by)

func set_carried_transform(holder_pos: Vector2, carry_offset: Vector2) -> void:
	print("carry move, vase=", vase)
	if vase == null:
		return
	vase.global_position = holder_pos + carry_offset
	
func _arm_hitbox_later(thrower: Node) -> void:
	if _arming_running:
		return
	_arming_running = true
	call_deferred("_arm_async", thrower)

func _arm_async(thrower: Node) -> void:
	await get_tree().create_timer(hit_arm_delay).timeout
	if vase and not vase.broken:
		vase.arm_hitbox(true, thrower)
	_arming_running = false
