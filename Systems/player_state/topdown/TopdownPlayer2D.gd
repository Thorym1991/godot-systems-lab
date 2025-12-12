extends CharacterBody2D
class_name TopdownPlayer2D

@export var speed: float = 150.0

var input_dir := Vector2.ZERO

func move_dir(dir: Vector2) -> void:
	input_dir = dir


func _physics_process(delta: float) -> void:
	# 1) Input lesen
	var input_dir := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	# 2) Bewegung berechnen
	var motion := input_dir * speed * delta

	# 3) Player bewegen (und Kollision bekommen)
	var collision := move_and_collide(motion)

	# 4) Wenn wir gegen etwas laufen: pushen versuchen
	if collision and input_dir != Vector2.ZERO:
		var collider := collision.get_collider()
		if collider and collider.is_in_group("pushable"):
			var block := collider as MovableBlock2D
			if block and block.try_move(input_dir, delta):
				# Block hat Platz gemacht → Player bewegt sich nochmal
				move_and_collide(motion)
