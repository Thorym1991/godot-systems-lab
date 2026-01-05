extends PlayerState

@export var carry_offset := Vector2(0, -20)
@export var throw_force := 480.0
@export var throw_if_moving := true

func id() -> StringName:
	return &"carry"

func enter(previous: PlayerState) -> void:
	var p := character as TopdownPlayer2D
	if p.carried == null:
		machine.change(&"idle")
		return
	p.carried.on_pickup(p)

func physics_update(delta: float) -> void:
	var p := character as TopdownPlayer2D
	var c := p.carried
	if c == null:
		machine.change(&"idle")
		return

	# Carry follow
	c.set_carried_transform(p.global_position, carry_offset)

	# Player bewegen
	var dir := p.input_dir
	character.velocity = dir.normalized() * p.speed if dir != Vector2.ZERO else Vector2.ZERO
	character.move_and_slide()

	# Release -> drop oder throw
	if not Input.is_action_pressed("interact"):
		var wants_throw := throw_if_moving and dir.length() > 0.6

		if wants_throw:
			var locked := dir
			if abs(locked.x) > abs(locked.y):
				locked = Vector2(sign(locked.x), 0.0)
			else:
				locked = Vector2(0.0, sign(locked.y))

			c.on_throw(p, locked.normalized(), throw_force)
			# 🔊 Sound
			feedbackBus.sfx_requested.emit(
			&"throw",
			p.global_position,
			-6.0,
			randf_range(0.98, 1.02)
			)

			# 📸 kleiner Kamera-Kick (Kickback)
			feedbackBus.impulse_requested.emit(
			-locked.normalized(),
			6.0,
			0.08
			)
		else:
			c.on_drop(p)
			feedbackBus.sfx_requested.emit(
			&"drop",
			p.global_position,
			-10.0,
			1.0
			)

		p.carried = null
		machine.change(&"idle")
		return
