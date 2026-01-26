extends EnemyState
class_name OktorokStateIdle

func id() -> StringName:
	return &"idle"

func enter() -> void:
	enemy.velocity = Vector2.ZERO

func physics_process(_delta: float) -> void:
	if enemy.has_method("has_target") and enemy.has_target():
		machine.change(&"emerge")
