extends PlayerState

func id() -> StringName:
	return &"idle"

func physics_update(delta: float) -> void:
	character.velocity = Vector2.ZERO

	var p := character as TopdownPlayer2D
	if p.is_grabbing():
		machine.change(&"grab")
		return

	if p.input_dir != Vector2.ZERO:
		machine.change(&"move")
