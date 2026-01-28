extends EnemyState
class_name PaintingStateDead

func id() -> StringName:
	return &"dead"

func enter() -> void:
	var e := enemy as PaintingArm2D

	e.set_attack_active(false)
	e.play_dead()

	if e.hurtbox:
		e.hurtbox.set_deferred("monitoring", false)
		e.hurtbox.set_deferred("monitorable", false)
