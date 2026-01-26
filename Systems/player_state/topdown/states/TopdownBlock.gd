extends PlayerState
class_name PlayerStateBlock

func id() -> StringName:
	return &"block"

func enter(previous: PlayerState) -> void:
	var p := character as TopdownPlayer2D
	p.shield_block_hitbox.monitoring = true
	p.shield_block_hitbox.monitorable = true
	p.velocity = Vector2.ZERO

func exit(next: PlayerState) -> void:
	var p := character as TopdownPlayer2D
	p.shield_block_hitbox.monitoring = false
	p.shield_block_hitbox.monitorable = false

func physics_update(_delta: float) -> void:
	var p := character as TopdownPlayer2D
	print("block an")

	# optional: langsam bewegen beim Blocken
	# var dir := p.input_dirccc
	# p.velocity = dir.normalized() * (p.speed * 0.25)
	# p.move_and_slide()

	# Block loslassen -> idle
	if not Input.is_action_pressed("block"):
		machine.change(&"idle")

func input(_event: InputEvent) -> void:
	pass
