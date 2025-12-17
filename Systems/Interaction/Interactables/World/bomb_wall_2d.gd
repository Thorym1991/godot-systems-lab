extends StaticBody2D
class_name BombWall2D

func on_explosion(_origin: Vector2, _force: float) -> void:
	print("[BombWall] destroyed by explosion")
	queue_free()
