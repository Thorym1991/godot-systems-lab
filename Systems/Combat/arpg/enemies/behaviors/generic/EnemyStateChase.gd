extends EnemyState
class_name EnemyStateChase

func id() -> StringName:
	return &"chase"

func physics_process(_delta: float) -> void:
	var active := bool(enemy.get("_active"))
	var target := enemy.get("_target") as Node2D
	if not active or target == null:
		machine.change(&"idle")
		return

	# erwartet: Enemy hat export var speed
	var spd := float(enemy.get("speed"))
	var dir := (target.global_position - enemy.global_position)
	if dir.length() > 4.0:
		enemy.velocity = dir.normalized() * spd
	else:
		enemy.velocity = Vector2.ZERO

	enemy.move_and_slide()
