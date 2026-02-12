extends EnemyState
class_name PaintingStateWarn

@export var warn_time: float = 0.0

func id() -> StringName:
	return &"warn"

func enter() -> void:
	# Warn-Visuals macht jetzt der Slot, nicht die Ability.
	if warn_time > 0.0:
		await get_tree().create_timer(warn_time).timeout
	machine.change(&"attack")
