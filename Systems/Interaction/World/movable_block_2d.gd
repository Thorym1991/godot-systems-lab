extends CharacterBody2D
class_name MovableBlock2D

@export var move_speed: float = 70.0
@export var four_directions_only: bool = true


func try_move(dir: Vector2, delta: float) -> bool:
	# dir = gewünschte Bewegungsrichtung
	if dir == Vector2.ZERO:
		return false

	var d := dir.normalized()

	# Optional: nur 4 Richtungen wie Zelda
	if four_directions_only:
		d = _to_cardinal(d)

	var motion := d * move_speed * delta

	# Wenn da was blockiert -> kann nicht bewegen
	if test_move(global_transform, motion):
		return false

	# Kinematisch verschieben (stabil)
	move_and_collide(motion)
	return true


func _to_cardinal(v: Vector2) -> Vector2:
	# wählt die dominante Achse (rechts/links oder hoch/runter)
	if abs(v.x) > abs(v.y):
		return Vector2(sign(v.x), 0.0)
	return Vector2(0.0, sign(v.y))
