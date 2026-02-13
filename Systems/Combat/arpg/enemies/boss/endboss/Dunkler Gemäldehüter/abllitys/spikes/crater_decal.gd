extends Node2D
class_name CraterDecal

@export var life_time: float = 8.0

func _ready() -> void:
	await get_tree().create_timer(life_time).timeout
	queue_free()
