extends EnemyState
class_name PaintingStateIdle

func id() -> StringName:
	return &"idle"

func enter() -> void:
	var e: PaintingAbilityArm = enemy as PaintingAbilityArm
	if e == null:
		return

	e.set_attack_active(false)
	# Kein Timer, kein machine.change() hier!
