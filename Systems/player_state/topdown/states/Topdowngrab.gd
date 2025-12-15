extends PlayerState

func id() -> StringName:
	return &"grab"

func enter(previous: PlayerState) -> void:
	var p := character as TopdownPlayer2D
	if not p.is_grabbing():
		machine.change(&"idle")

func physics_update(delta: float) -> void:
	var p := character as TopdownPlayer2D

	# 🔴 WICHTIG: Wenn Interact NICHT gehalten wird → loslassen
	if not Input.is_action_pressed("interact"):
		p.release_grab()
		machine.change(&"idle")
		return

	var block := p.get_grabbed_block()
	if block == null:
		machine.change(&"idle")
		return

	var dir := p.input_dir

	# Zelda-Style 4-Richtungs-Lock
	if dir != Vector2.ZERO:
		if abs(dir.x) > abs(dir.y):
			dir = Vector2(sign(dir.x), 0.0)
		else:
			dir = Vector2(0.0, sign(dir.y))

	# Block schieben
	var moved := block.push(dir, delta)

	# Player klebt am Block
	if moved != Vector2.ZERO:
		character.velocity = moved / max(delta, 0.001)
	else:
		character.velocity = Vector2.ZERO

	character.move_and_slide()
