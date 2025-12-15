extends RigidBody2D
class_name VaseShard2D

@export var lifetime: float = 10.0

func _ready() -> void:
	gravity_scale = 0.0
	lock_rotation = false
	# nach lifetime löschen
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
