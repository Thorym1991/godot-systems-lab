extends StaticBody2D
class_name BombWall2D

@onready var shards: BreakableShards2D = $BreakableShards2D


func on_explosion(_origin: Vector2, _force: float) -> void:
	if shards:
		shards.spawn(global_position)
	queue_free()
