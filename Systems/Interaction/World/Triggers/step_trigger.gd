extends Node2D

signal triggered(body: Node)

@export var target_gate: Gate
@export_enum("Open", "Close", "Toggle") var action := "Open"
@export var only_player: bool = true

@onready var area: Area2D = $Area2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var _used := false

func _ready() -> void:
	print("StepTrigger READY:", name)
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	print("StepTrigger BODY ENTERED:", body.name)

	if _used:
		return

	if only_player and not body.is_in_group("player"):
		return

	_used = true
	emit_signal("triggered", body)

	if anim_player and anim_player.has_animation("trigger"):
		anim_player.play("trigger")

	if target_gate:
		match action:
			"Open":
				target_gate.open_gate()
			"Close":
				target_gate.close_gate()
			"Toggle":
				target_gate.toggle_gate()
