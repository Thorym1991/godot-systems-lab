extends RigidBody2D
class_name ShardPiece2D

@export var lifetime: float = 6.0
@export var use_gravity: bool = false
@export var allow_rotation: bool = true
@export var disable_collision_after: float = 0.15

@onready var _collider: CollisionShape2D = get_node_or_null("CollisionShape2D") as CollisionShape2D

func _ready() -> void:
	gravity_scale = 1.0 if use_gravity else 0.0
	lock_rotation = not allow_rotation

	if disable_collision_after > 0.0 and _collider:
		get_tree().create_timer(disable_collision_after).timeout.connect(func ():
			if is_instance_valid(_collider):
				_collider.disabled = true
		)

	if lifetime > 0.0:
		get_tree().create_timer(lifetime).timeout.connect(queue_free)
