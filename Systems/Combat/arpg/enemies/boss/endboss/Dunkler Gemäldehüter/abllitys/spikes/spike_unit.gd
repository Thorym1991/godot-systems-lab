extends Node2D
class_name SpikeUnit

@export var contact_damage: int = 1
@export var emerge_time: float = 0.18
@export var active_time: float = 0.25
@export var retract_time: float = 0.16

@export var crater_scene: PackedScene
@export var spawn_crater: bool = true

@onready var anim: AnimatedSprite2D = $Anim
@onready var hit_area: Area2D = $HitArea
@onready var hit_shape: CollisionShape2D = $HitArea/CollisionShape2D

func _ready() -> void:
	# Sicher: am Anfang kein Schaden
	_set_damage_enabled(false)

	# optional: wenn du body_entered nutzt
	hit_area.body_entered.connect(_on_body_entered)

	_run()

func _run() -> void:
	# EMERGE
	if anim:
		anim.play("emerge")
	await get_tree().create_timer(emerge_time).timeout

	# ACTIVE (Damage an)
	_set_damage_enabled(true)
	if anim:
		anim.play("active")
	await get_tree().create_timer(active_time).timeout

	# RETRACT (Damage aus)
	_set_damage_enabled(false)
	if anim:
		anim.play("retract")
	await get_tree().create_timer(retract_time).timeout

	# Crater
	if spawn_crater and crater_scene != null:
		var c := crater_scene.instantiate() as Node2D
		c.global_position = global_position
		get_tree().current_scene.add_child(c)

	queue_free()

func _set_damage_enabled(v: bool) -> void:
	hit_area.monitoring = v
	hit_area.monitorable = v
	if hit_shape:
		hit_shape.disabled = not v

func _on_body_entered(body: Node) -> void:
	if not hit_area.monitoring:
		return
	if body is TopdownPlayer2D:
		var p := body as TopdownPlayer2D
		if p.health and p.health.can_take_damage():
			p.health.take_damage(contact_damage, self)
