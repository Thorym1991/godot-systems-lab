extends Control

const DEMO_SCENES := {
	"platformer": "res://Demo/player_state_demo/Platformer/TestWorldPF.tscn",
	"topdown": "res://Demo/player_state_demo/Topdown/TestWorldTD.tscn",
	"interactdemo": "res://Demo/interaction_demo/topdown/interaction_TestWorld.tscn",
	"dungeondemo": "res://Demo/DungeonDemo/DungeonDemoTorch/DungeonDemo.tscn",
	"dungeondemoboss": "res://Demo/DungeonDemo/Dungeon ARPG Gameplay demo/Dungeon arpg demo.tscn"
}

func _ready() -> void:
	# Buttons an Signale binden
	$MarginContainer/HSplitContainer/VBoxContainer/PlatformerButton.pressed.connect(
		func(): _open_demo("platformer")
	)
	$MarginContainer/HSplitContainer/VBoxContainer/TopdownButton.pressed.connect(
		func(): _open_demo("topdown")
	)
	$MarginContainer/HSplitContainer/VBoxContainer2/TopdownInteractDemoButton.pressed.connect(
		func(): _open_demo("interactdemo")
	)
	$"MarginContainer/HSplitContainer/VBoxContainer2/Dungeon Demo".pressed.connect(
	func(): _open_demo("dungeondemo")
	)
	$"MarginContainer/HSplitContainer/VBoxContainer2/Dungeon Demoboss".pressed.connect(
	func(): _open_demo("dungeondemoboss")
	)

func _open_demo(key: String) -> void:
	if not DEMO_SCENES.has(key):
		push_warning("Demo key '%s' not mapped" % key)
		return
	
	var path = DEMO_SCENES[key]

	get_tree().change_scene_to_file(path)
