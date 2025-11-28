extends CanvasLayer

@export var hub_scene_path: String = "res://Demo/DemoHub.tscn"

func _ready() -> void:
	$MarginContainer/HBoxContainer/BackButton.pressed.connect(_on_back_pressed)

func _on_back_pressed() -> void:
	if hub_scene_path.is_empty():
		push_warning("No hub_scene_path set on DemoBackHUD")
		return
	get_tree().change_scene_to_file(hub_scene_path)
