extends Node
class_name RoomLockController

@export var trigger_path: NodePath
@export var door_paths: Array[NodePath] = []
@export var enemy_group: StringName = &"room_enemy"

@export var lock_on_enter: bool = true
@export var unlock_when_clear: bool = true

var _active := false

func _ready() -> void:
	var trigger := get_node_or_null(trigger_path) as Area2D
	if trigger:
		trigger.body_entered.connect(_on_enter)

func _on_enter(body: Node) -> void:
	if _active:
		return
	if not (body is TopdownPlayer2D):
		return

	_active = true
	if lock_on_enter:
		_set_locked(true)

func _physics_process(_delta: float) -> void:
	if not _active:
		return
	if not unlock_when_clear:
		return

	# Wenn keine Enemies mehr in der Gruppe: unlock
	if get_tree().get_nodes_in_group(String(enemy_group)).is_empty():
		_set_locked(false)
		_active = false

func _set_locked(v: bool) -> void:
	for p in door_paths:
		var d := get_node_or_null(p)
		if d and d.has_method("set_locked"):
			d.call("set_locked", v)
