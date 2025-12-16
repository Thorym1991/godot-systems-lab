extends PlayerState

@export var release_on_button_up: bool = true

func id() -> StringName:
	return &"grab"

func enter(previous: PlayerState) -> void:
	var p := character as TopdownPlayer2D
	if p.grabbed_block == null:
		machine.change(&"idle")
		return

	p.grabbed_block.grab(character)

func exit(next: PlayerState) -> void:
	var p := character as TopdownPlayer2D
	if p.grabbed_block:
		p.grabbed_block.release()
	p.stop_grab()

func physics_update(delta: float) -> void:
	var p := character as TopdownPlayer2D
	var block := p.grabbed_block
	if block == null:
		machine.change(&"idle")
		return

	# Hold-to-grab: loslassen => release
	if release_on_button_up and not Input.is_action_pressed("interact"):
		block.release()
		p.stop_grab()
		machine.change(&"idle")
		return

	# Input
	var dir := p.input_dir
	if dir == Vector2.ZERO:
		character.velocity = Vector2.ZERO
		character.move_and_slide()
		return

	# Zelda 4-dir lock
	if abs(dir.x) > abs(dir.y):
		dir = Vector2(sign(dir.x), 0.0)
	else:
		dir = Vector2(0.0, sign(dir.y))

	# Block bewegen
	var moved := block.push(dir, delta)

	# Player "klebt" am Block: gleiche Bewegung versuchen
	if moved != Vector2.ZERO:
		character.move_and_collide(moved)
	else:
		character.velocity = Vector2.ZERO
		character.move_and_slide()
