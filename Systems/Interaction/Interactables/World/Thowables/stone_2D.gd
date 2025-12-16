extends RigidBody2D
class_name Stone2D

@export var max_speed: float = 520.0
@export var linear_damp_world: float = 8.0
@export var linear_damp_carried: float = 20.0

func _ready() -> void:
	gravity_scale = 0.0
	lock_rotation = true
	linear_damp = linear_damp_world

func _physics_process(_delta: float) -> void:
	# Safety clamp gegen "yeeten"
	var v := linear_velocity
	if v.length() > max_speed:
		linear_velocity = v.normalized() * max_speed

func enable_physics(enabled: bool) -> void:
	# Beim Tragen -> Physik "aus" (freeze)
	freeze = not enabled
	if enabled:
		linear_damp = linear_damp_world
	else:
		linear_damp = linear_damp_carried
		linear_velocity = Vector2.ZERO
