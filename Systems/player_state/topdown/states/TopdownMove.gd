extends PlayerState

func id() -> StringName:
	return &"move"

func physics_update(delta: float) -> void:
	var p := character as TopdownPlayer2D

	# Grab hat Priorität
	if p.is_grabbing():
		machine.change(&"grab")
		return
	
	if Input.is_action_just_pressed("attack") and machine.current.id() != &"attack":
		machine.change(&"attack")
		return


	
	var dir := p.input_dir
	if dir == Vector2.ZERO:
		machine.change(&"idle")
		return

	# Wie vorher: Schrittweise Kollision + Pushable TryMove
	var motion := dir.normalized() * p.speed * delta
	var collision := character.move_and_collide(motion)

	if collision:
		var collider := collision.get_collider()
		if collider and collider.is_in_group("pushable"):
			var block := collider as MovableBlock2D
			if block and block.try_move(dir, delta):
				# Block hat Platz gemacht → Player bewegt sich nochmal
				character.move_and_collide(motion)
	else:
		# Freier Weg: velocity für andere Systeme (Animation) setzen
		character.velocity = dir.normalized() * p.speed
