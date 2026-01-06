extends RigidBody2D
class_name Vase2D

@export var block_collider_path: NodePath = NodePath("BlockCollider")
@export var hit_area_path: NodePath = NodePath("Hitarea")

@onready var shards: BreakableShards2D = $BreakableShards2D
@onready var block_collider: CollisionShape2D = get_node_or_null(block_collider_path) as CollisionShape2D
@onready var hit_area: Area2D = get_node_or_null(hit_area_path) as Area2D
@onready var loot: LootDropper2D = $Lootdropper2D

var broken := false
var armed := false
var thrower: Node = null

func _ready() -> void:
	gravity_scale = 0.0
	lock_rotation = true

	if hit_area:
		hit_area.monitoring = false
		hit_area.body_entered.connect(_on_hit_body)

func enable_physics(enabled: bool) -> void:
	if block_collider:
		block_collider.set_deferred("disabled", not enabled)

func arm_hitbox(enable: bool, by: Node = null) -> void:
	armed = enable
	thrower = by
	if hit_area:
		hit_area.set_deferred("monitoring", enable)

func _on_hit_body(body: Node) -> void:
	if broken or not armed:
		return
	if body == thrower:
		return
	break_vase()

func break_vase() -> void:
	if broken:
		return
	broken = true
	feedbackBus.sfx_requested.emit(&"pot_break", global_position, -6.0, randf_range(0.95, 1.05))
	if is_instance_valid(shards):
		shards.spawn(global_position)
	if is_instance_valid(loot):
		loot.drop(global_position)
	queue_free()

func on_explosion(_pos: Vector2, _force: float) -> void:
	if broken:
		return
	await get_tree().create_timer(0.05).timeout
	break_vase()
