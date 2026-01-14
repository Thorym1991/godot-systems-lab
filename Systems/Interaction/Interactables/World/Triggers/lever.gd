extends Interactable2D
class_name Lever2D

signal toggled(is_on: bool)

@export var target: Node
@export_enum("Open", "Close", "Toggle") var on_on := "Open"
@export_enum("Open", "Close", "Toggle") var on_off := "Close"

@onready var anim_player: AnimationPlayer = $AnimationPlayer

var is_on := false

func interact(_interactor: Node) -> void:
	is_on = !is_on

	if anim_player:
		var anim := "on" if is_on else "off"
		if anim_player.has_animation(anim):
			anim_player.play(anim)

	toggled.emit(is_on)

	_apply_target_action(target, on_on if is_on else on_off)

func _apply_target_action(target: Node, action: String) -> void:
	# (Helper aus oben hier rein kopieren)
	if target == null: return
	# Door API...
	if target.has_method("open_door") or target.has_method("close_door"):
		match action:
			"Open":
				if target.has_method("open_door"): target.call_deferred("open_door")
			"Close":
				if target.has_method("close_door"): target.call_deferred("close_door")
			"Toggle":
				if "is_open" in target and target.has_method("open_door") and target.has_method("close_door"):
					if target.is_open: target.call_deferred("close_door")
					else: target.call_deferred("open_door")
		return
	# Gate API...
	if target.has_method("open_gate") or target.has_method("close_gate") or target.has_method("toggle_gate"):
		match action:
			"Open":
				if target.has_method("open_gate"): target.call_deferred("open_gate")
			"Close":
				if target.has_method("close_gate"): target.call_deferred("close_gate")
			"Toggle":
				if target.has_method("toggle_gate"): target.call_deferred("toggle_gate")
