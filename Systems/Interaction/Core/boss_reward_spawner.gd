extends Node2D
class_name BossRewardSpawner

@export var enemy_group: StringName = &"boss_enemy"
@export var chest_scene: PackedScene
@export var spawn_marker_path: NodePath

var _done := false

func _physics_process(_delta: float) -> void:
	if _done:
		return

	if get_tree().get_nodes_in_group(String(enemy_group)).is_empty():
		_spawn_chest()
		_done = true

func _spawn_chest() -> void:
	if chest_scene == null:
		return

	var marker := get_node_or_null(spawn_marker_path) as Node2D
	var chest := chest_scene.instantiate() as Node2D
	get_tree().current_scene.add_child(chest)

	chest.global_position = marker.global_position if marker else global_position
