extends EnemyState
class_name OktorokStateShoot

func id() -> StringName:
	return &"shoot"

@export var shoot_interval: float = 1.2
@export var projectile_scene: PackedScene
@export var projectile_speed: float = 180.0
@export var projectile_damage: int = 1
@export var projectile_knockback: float = 80.0
@export var spawn_offset: float = 10.0

var _t: float = 0.0

func enter() -> void:
	_t = 0.0
	enemy.velocity = Vector2.ZERO

func physics_process(delta: float) -> void:
	if bool(enemy.get("is_dead")):
		return

	var active := bool(enemy.get("_active"))
	var target := enemy.get("_target") as Node2D
	if not active or target == null:
		machine.change(&"idle")
		return

	_t -= delta
	if _t > 0.0:
		return

	_t = shoot_interval
	_shoot(target)

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

	# Spawn
	if p is Node2D:
		(p as Node2D).global_position = enemy.global_position + dir * spawn_offset

	# Setup (wenn es Projectile2D ist)
	if p is Projectile2D:
		var pr := p as Projectile2D
		pr.speed = projectile_speed
		pr.setup(dir, projectile_damage, enemy, projectile_knockback)

	get_tree().current_scene.add_child(p)
