extends EnemyState
class_name PaintingStateDead

func id() -> StringName:
	return &"dead"

func enter() -> void:
	var e: PaintingAbilityArm = enemy as PaintingAbilityArm
	if e == null:
		return

	e.is_dead = true
	e.set_attack_active(false)

	# Optional: Slot informieren (wenn du dead/broken über den Slot zeigen willst)
	if e.slot:
		e.slot.set_broken(true)
