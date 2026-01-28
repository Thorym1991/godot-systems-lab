extends EnemyState
class_name PaintingStateIdle

@export var idle_time: float = 1.2

func id() -> StringName:
	return &"idle"

func enter() -> void:
	var e := enemy as PaintingArm2D

	e.set_attack_active(false)
	e.play_idle()

	await get_tree().create_timer(idle_time).timeout

	if not e.is_dead:
		machine.change(&"warn")
