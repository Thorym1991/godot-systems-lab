extends RigidBody2D
class_name Vase2D

@export var block_collider_path: NodePath = NodePath("BlockCollider")
@export var hit_area_path: NodePath = NodePath("Hitarea")
@export var shards_scene: PackedScene
@export var shards_lifetime: float = 5.0
@export var shard_scenes: Array[PackedScene] = []
@export var shard_weights: Array[int] = [6, 4, 2, 1] # klein -> groß
@export var shards_count: int = 10
@export var shards_spread: float = 180.0



@onready var block_collider: CollisionShape2D = get_node_or_null(block_collider_path) as CollisionShape2D
@onready var hit_area: Area2D = get_node_or_null(hit_area_path) as Area2D

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
	# SFX sofort (bevor deferred break + queue_free)
	feedbackBus.sfx_requested.emit(&"pot_break", global_position, -6.0, randf_range(0.95, 1.05))
	call_deferred("_do_break")

func _do_break() -> void:
	if shard_scenes.is_empty():
		queue_free()
		return

	for i in range(shards_count):
		var scene := _pick_weighted_scene()
		if scene == null:
			continue

		var shard := scene.instantiate()
		get_parent().add_child(shard)

		if shard is Node2D:
			(shard as Node2D).global_position = global_position

		if shard is RigidBody2D:
			var rb := shard as RigidBody2D
			rb.gravity_scale = 0.0
			rb.lock_rotation = false
			rb.rotation = randf() * TAU
			rb.angular_velocity = randf_range(-12.0, 12.0)

			# grobe "Größe" über Scale (bei dir unterschiedlich)
			var size_factor := 1.0
			if shard is Node2D:
				size_factor = max((shard as Node2D).scale.x, 0.5)

			var angle := randf() * TAU
			var dir := Vector2(cos(angle), sin(angle))

			# große Splitter bekommen weniger Impuls
			var strength := randf_range(shards_spread * 0.5, shards_spread * 1.2) / size_factor
			rb.apply_impulse(dir * strength)

	queue_free()


func _pick_weighted_scene() -> PackedScene:
	if shard_scenes.is_empty():
		return null

	var total := 0
	for w in shard_weights:
		total += max(w, 0)

	if total <= 0:
		return shard_scenes[randi() % shard_scenes.size()]

	var r := randi() % total
	var acc := 0
	for i in range(shard_scenes.size()):
		acc += max(shard_weights[i], 0)
		if r < acc:
			return shard_scenes[i]

	return shard_scenes[0]

func on_explosion(_pos: Vector2, _force: float) -> void:
	if broken:
		return
		await get_tree().create_timer(0.05).timeout
	break_vase()
	
