extends PlayerState

func id() -> StringName:
	return &"idle"

func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and machine.current.id() != &"attack":
		machine.change(&"attack")
		return


	character.velocity = Vector2.ZERO

	var p := character as TopdownPlayer2D
	if p.is_grabbing():
		machine.change(&"grab")
		return

	if p.input_dir != Vector2.ZERO:
		machine.change(&"move")
