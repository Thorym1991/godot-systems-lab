extends PlayerState

func id() -> StringName:
	return &"idle"

func physics_update(delta: float) -> void:
	# Spieler wirklich stoppen
	character.velocity = Vector2.ZERO

	# Wenn Input vorhanden → wechseln zu Move
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if dir != Vector2.ZERO:
		machine.change(&"move")
