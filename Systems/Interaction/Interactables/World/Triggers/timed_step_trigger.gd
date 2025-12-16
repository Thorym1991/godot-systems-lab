extends Node2D
class_name TimedStepTrigger

signal triggered(body: Node)
signal reset

@export var target_gate: Gate
@export_enum("Open", "Close", "Toggle") var action := "Open"
@export var only_player: bool = true

@export var reset_after_time: bool = true
@export var reset_time: float = 3.0

@export var reset_gate_on_timeout: bool = true
@export var reusable: bool = true

@onready var area: Area2D = $Area2D
@onready var timer: Timer = $Timer
@onready var anim_player: AnimationPlayer = get_node_or_null("AnimationPlayer")

var _used := false


func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	timer.timeout.connect(_on_timeout)


func _on_body_entered(body: Node) -> void:
	if _used:
		return

	if only_player and not body.is_in_group("player"):
		return

	_used = true
	emit_signal("triggered", body)

	if anim_player and anim_player.has_animation("trigger"):
		anim_player.play("trigger")

	_do_action()

	if reset_after_time:
		timer.start(reset_time)


func _on_timeout() -> void:
	emit_signal("reset")

	if anim_player and anim_player.has_animation("reset"):
		anim_player.play("reset")

	if reset_gate_on_timeout:
		_undo_action()

	if reusable:
		_used = false
	else:
		area.monitoring = false
		area.monitorable = false


func _do_action() -> void:
	if not target_gate:
		return

	match action:
		"Open":
			target_gate.open_gate()
		"Close":
			target_gate.close_gate()
		"Toggle":
			target_gate.toggle_gate()


func _undo_action() -> void:
	if not target_gate:
		return

	match action:
		"Open":
			target_gate.close_gate()
		"Close":
			target_gate.open_gate()
		"Toggle":
			target_gate.toggle_gate()
