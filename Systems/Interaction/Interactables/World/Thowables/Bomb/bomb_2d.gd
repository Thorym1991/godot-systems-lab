extends RigidBody2D
class_name Bomb2D

@export var fuse_time: float = 2.5
@export var explosion_force: float = 500.0

@onready var explosion_area: Area2D = $ExplosionArea
@onready var anim: AnimationPlayer = $AnimationPlayer
@export var explosion_fx: PackedScene

var _armed := false
var _exploded := false

func _ready() -> void:
	gravity_scale = 0
	lock_rotation = true
	explosion_area.monitoring = false

func arm() -> void:
	if _armed:
		return
	_armed = true
	
	if anim and anim.has_animation("fuse"):
		anim.play("fuse")
	else:
		push_warning("[Bomb] Animation 'boom' not found")

	
	await get_tree().create_timer(fuse_time).timeout
	explode()

func explode() -> void:
	if _exploded:
		return
	_exploded = true
	# Feedback
	feedbackBus.shake_requested.emit(12.0, 0.20)
	feedbackBus.sfx_requested.emit(&"explosion", global_position, -2.0, randf_range(0.95, 1.05))


	if explosion_area == null or not is_instance_valid(explosion_area):
		push_error("[Bomb] ExplosionArea missing!")
		queue_free()
		return

	# ExplosionArea aktivieren
	explosion_area.monitoring = true
	await get_tree().physics_frame
	await get_tree().physics_frame

	# FX spawnen (nachdem sicher ist, dass wir wirklich explodieren)
	if explosion_fx:
		var fx := explosion_fx.instantiate()
		get_parent().add_child(fx)
		fx.global_position = global_position

	var bodies := explosion_area.get_overlapping_bodies()
	var areas := explosion_area.get_overlapping_areas()

	for b in bodies:
		if b == self:
			continue
		if b.has_method("on_explosion"):
			b.on_explosion(global_position, explosion_force)

	for a in areas:
		# InteractableArea / Carryable Area willst du i.d.R. nicht treffen
		if a.has_method("on_explosion"):
			a.on_explosion(global_position, explosion_force)

	queue_free()
