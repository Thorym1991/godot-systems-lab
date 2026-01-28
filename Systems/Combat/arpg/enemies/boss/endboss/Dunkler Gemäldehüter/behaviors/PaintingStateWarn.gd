extends EnemyState
class_name PaintingStateWarn

@export var warn_time: float = 0.4

func id() -> StringName:
	return &"warn"

func enter() -> void:
	var e := enemy as PaintingArm2D

	e.set_attack_active(false)
	e.play_warn()

	await get_tree().create_timer(warn_time).timeout

	if not e.is_dead:
		machine.change(&"attack")
