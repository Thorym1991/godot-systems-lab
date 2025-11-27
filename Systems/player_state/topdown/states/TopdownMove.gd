extends PlayerState

func id() -> StringName:
	return &"move"

func physics_update(delta: float) -> void:
	var raw := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if raw == Vector2.ZERO:
		machine.change(&"idle")
		return

	var dir := raw
	# 4-Way: nur die stärkere Achse behalten
	if abs(raw.x) > abs(raw.y):
		dir = Vector2(sign(raw.x), 0.0)
	else:
		dir = Vector2(0.0, sign(raw.y))

	character.move_dir(dir)
