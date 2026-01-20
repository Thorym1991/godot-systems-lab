extends Area2D
class_name Projectile2D

@export var speed: float = 220.0
@export var lifetime: float = 1.6
@export var collide_with_world: bool = true

var dir: Vector2 = Vector2.RIGHT
var damage: int = 1
var knockback: float = 80.0
var source: Node = null

var _life_left: float = 0.0

func _ready() -> void:
	_life_left = lifetime
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func setup(_dir: Vector2, _damage: int, _source: Node, _knockback: float = 80.0) -> void:
	dir = _dir.normalized()
	damage = _damage
	source = _source
	knockback = _knockback

	rotation = dir.angle()


func _physics_process(delta: float) -> void:
	global_position += dir * speed * delta

	_life_left -= delta
	if _life_left <= 0.0:
		queue_free()

func _on_area_entered(a: Area2D) -> void:
	if a == null:
		return
	if not a.has_method("apply_hit"):
		return

	# Ziel-Owner (bei dir Hurtbox2D sitzt meist als Child -> parent ist Enemy)
	var owner := a.get_parent()
	if owner == source:
		return

	# HitData bauen (minimal)
	var hit := HitData.new()
	hit.damage = damage
	hit.source = source
	hit.dir = dir
	hit.knockback = knockback

	a.call("apply_hit", hit)
	queue_free()

func _on_body_entered(b: Node) -> void:
	# Player hit
	if b is TopdownPlayer2D:
		var p := b as TopdownPlayer2D
		if p.health and p.health.can_take_damage():
			p.health.take_damage(damage, source)
		queue_free()
		return

	# World hit (walls/tilemap)
	if collide_with_world:
		queue_free()
