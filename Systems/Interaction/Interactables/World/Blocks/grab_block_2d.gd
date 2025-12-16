extends CharacterBody2D
class_name GrabBlock2D

signal grabbed(grabber: Node)
signal released(grabber: Node)

@export var push_speed: float = 70.0

var grabber: CharacterBody2D = null


func grab(by: CharacterBody2D) -> void:
	if grabber == by:
		return
	if grabber != null:
		release()

	grabber = by

	# damit Player nicht den Block "blockiert" beim schieben
	add_collision_exception_with(by)
	by.add_collision_exception_with(self)

	grabbed.emit(by)


func release() -> void:
	if grabber == null:
		return

	var by := grabber
	grabber = null
	velocity = Vector2.ZERO

	remove_collision_exception_with(by)
	by.remove_collision_exception_with(self)

	released.emit(by)


func is_grabbed() -> bool:
	return grabber != null


func is_grabbed_by(node: Node) -> bool:
	return grabber == node


# Wird vom Grab-State aufgerufen (Zelda Push)
# Gibt zurück, wie weit der Block wirklich kam.
func push(dir: Vector2, delta: float) -> Vector2:
	if grabber == null:
		return Vector2.ZERO
	if dir == Vector2.ZERO:
		return Vector2.ZERO

	var before := global_position
	var motion := dir.normalized() * push_speed * delta
	move_and_collide(motion)
	return global_position - before
