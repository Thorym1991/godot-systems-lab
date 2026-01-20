extends Area2D
class_name AggroSensor2D

signal target_acquired(target: Node2D)
signal target_lost()

@export var aggro_range: float = 120.0
@export var deaggro_range: float = 160.0
@export var forget_time: float = 0.8

@export var self_group: StringName = &"enemy"
@export var target_groups: Array[StringName] = [ &"player" ]
@export var allow_friendly_fire: bool = false

@onready var shape: CollisionShape2D = $CollisionShape2D

var target: Node2D = null
var has_target: bool = false

var _forget_left: float = 0.0
var _owner: Node2D

func _ready() -> void:
	_owner = get_parent() as Node2D

	var c := CircleShape2D.new()
	c.radius = aggro_range
	shape.shape = c

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if not has_target or target == null or _owner == null:
		return

	var d := _owner.global_position.distance_to(target.global_position)
	if d > deaggro_range:
		_forget_left = maxf(_forget_left - delta, 0.0)
		if _forget_left <= 0.0:
			_clear()
	else:
		_forget_left = forget_time

func _is_valid_target(n: Node) -> bool:
	if n == null:
		return false
	if (not allow_friendly_fire) and n.is_in_group(self_group):
		return false
 
	for g in target_groups:
		if n.is_in_group(g):
			return true
	return false

func _on_body_entered(body: Node) -> void:
	if has_target:
		return
	if _is_valid_target(body):
		target = body as Node2D
		has_target = (target != null)
		if has_target:
			_forget_left = forget_time
			set_physics_process(true)
			target_acquired.emit(target)

func _on_body_exited(body: Node) -> void:
	if body == target:
		_forget_left = forget_time

func _clear() -> void:
	target = null
	has_target = false
	_forget_left = 0.0
	set_physics_process(false)
	target_lost.emit()
