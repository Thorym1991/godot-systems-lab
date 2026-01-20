extends EnemyState
class_name EnemyStateHurt

func id() -> StringName:
	return &"hurt"

func enter() -> void:
	print("[State] hurt enter")

func physics_process(delta: float) -> void:
	var t := float(enemy.get("_hurt_time_left"))
	t = maxf(t - delta, 0.0)
	enemy.set("_hurt_time_left", t)

	enemy.move_and_slide()

	if t <= 0.0:
		var next_id := enemy.get("_hurt_recover_state") as StringName
		if next_id == StringName():
			next_id = &"idle"
		machine.change(next_id)
