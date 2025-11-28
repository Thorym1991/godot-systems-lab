extends Control

const DEMO_SCENES := {
	"platformer": "res://Demo/player_state_demo/Platformer/TestWorldPF.tscn",
	"topdown": "res://Demo/player_state_demo/Topdown/TestWorldTD.tscn",
}

func _ready() -> void:
	# Buttons an Signale binden
	$MarginContainer/CenterContainer/VBoxContainer/PlatformerButton.pressed.connect(
		func(): _open_demo("platformer")
	)
	$MarginContainer/CenterContainer/VBoxContainer/TopdownButton.pressed.connect(
		func(): _open_demo("topdown")
	)


func _open_demo(key: String) -> void:
	if not DEMO_SCENES.has(key):
		push_warning("Demo key '%s' not mapped" % key)
		return
	
	var path = DEMO_SCENES[key]

	get_tree().change_scene_to_file(path)
