extends PlayerState

func id() -> StringName:
	return &"move"

func physics_update(delta: float) -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if dir == Vector2.ZERO:
		machine.change(&"idle")
		return

	character.move_dir(dir)
