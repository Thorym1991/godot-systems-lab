extends Node2D

signal triggered(body: Node)

@export var target: Node
@export_enum("Open", "Close", "Toggle") var action := "Open"
@export var only_player: bool = true

@onready var area: Area2D = $Area2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var _used := false

func _ready() -> void:
	print("StepTrigger READY:", name)
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if _used:
		return

	if only_player and not body.is_in_group("player"):
		return

	_used = true
	emit_signal("triggered", body)

	if anim_player and anim_player.has_animation("trigger"):
		anim_player.play("trigger")

	_apply_target_action(action)


func _apply_target_action(action: String) -> void:
	if target == null:
		return

	match action:
		"Open":
			if target.has_method("open_door"):
				target.call_deferred("open_door")
			elif target.has_method("open_gate"):
				target.call_deferred("open_gate")

		"Close":
			if target.has_method("close_door"):
				target.call_deferred("close_door")
			elif target.has_method("close_gate"):
				target.call_deferred("close_gate")

		"Toggle":
			# Gate hat echtes toggle
			if target.has_method("toggle_gate"):
				target.call_deferred("toggle_gate")

			# Door togglen wir über is_open + open/close
			elif ("is_open" in target
				and target.has_method("open_door")
				and target.has_method("close_door")):
				if target.is_open:
					target.call_deferred("close_door")
				else:
					target.call_deferred("open_door")
