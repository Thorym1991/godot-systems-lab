extends EnemyState
class_name OktorokStateShoot

func id() -> StringName:
	return &"shoot"

@export var post_shot_time: float = 0.25
@export var projectile_scene: PackedScene
@export var projectile_speed: float = 180.0
@export var projectile_damage: int = 1
@export var projectile_knockback: float = 80.0
@export var spawn_offset: float = 10.0

func enter() -> void:
	enemy.velocity = Vector2.ZERO

	# nur schießen, wenn Target da
	if bool(enemy.get("is_dead")):
		return

	var target := enemy.get("_target") as Node2D
	if not enemy.has_method("has_target") or not enemy.has_target() or target == null:
		machine.change(&"hide")
		return

	_shoot(target)

	# kurzer "sichtbar bleiben" Moment (später = Reflektions-Fenster)
	await get_tree().create_timer(post_shot_time).timeout

	machine.change(&"hide")

func physics_process(_delta: float) -> void:
	pass

func _shoot(target: Node2D) -> void:
	if projectile_scene == null:
		push_warning("Oktorok shoot: projectile_scene not set")
		return

	var p := projectile_scene.instantiate()
	if p == null:
		return

	var dir := (target.global_position - enemy.global_position)
	if dir.length() < 0.01:
		dir = Vector2.RIGHT
	dir = dir.normalized()

	if p is Node2D:
		(p as Node2D).global_position = enemy.global_position + dir * spawn_offset

	if p is Projectile2D:
		var pr := p as Projectile2D
		pr.speed = projectile_speed
		pr.setup(dir, projectile_damage, enemy, projectile_knockback)

	get_tree().current_scene.add_child(p)
