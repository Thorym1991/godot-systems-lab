extends Node2D
class_name BreakableShards2D

@export var shard_scenes: Array[PackedScene] = []
@export var shard_weights: Array[int] = []
@export var shards_count: int = 10
@export var spread_force: float = 180.0



func spawn(position: Vector2) -> void:
	if shard_scenes.is_empty():
		return

	for i in range(shards_count):
		var scene := _pick_weighted_scene()
		if scene == null:
			continue

		var shard := scene.instantiate()
		get_tree().current_scene.add_child(shard)

		if shard is Node2D:
			shard.global_position = position

		if shard is RigidBody2D:
			var rb := shard as RigidBody2D
			rb.rotation = randf() * TAU
			rb.angular_velocity = randf_range(-12.0, 12.0)

			var dir := Vector2.RIGHT.rotated(randf() * TAU)
			var strength := randf_range(spread_force * 0.5, spread_force * 1.2)
			rb.apply_impulse(dir * strength)

func _pick_weighted_scene() -> PackedScene:
	if shard_scenes.is_empty():
		return null

	if shard_weights.size() != shard_scenes.size():
		return shard_scenes.pick_random()

	var total: int = 0
	for w in shard_weights:
		total += maxi(w, 0)

	var denom: int = maxi(total, 1)
	var r: int = randi() % denom

	var acc: int = 0
	for i in range(shard_scenes.size()):
		acc += maxi(shard_weights[i], 0)
		if r < acc:
			return shard_scenes[i]

	return shard_scenes[0]
