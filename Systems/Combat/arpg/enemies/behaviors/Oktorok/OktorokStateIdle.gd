extends EnemyState
class_name OktorokStateIdle

func id() -> StringName:
	return &"idle"

func enter() -> void:
	enemy.velocity = Vector2.ZERO

func physics_process(_delta: float) -> void:
	var active := bool(enemy.get("_active"))
	var target := enemy.get("_target") as Node2D
	if active and target != null:
		machine.change(&"shoot")
