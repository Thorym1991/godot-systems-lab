extends Node2D
class_name TimedStepTrigger

signal triggered(body: Node)
signal reset

@export var target: Node
@export_enum("Open", "Close", "Toggle") var action := "Open"
@export var only_player: bool = true

@export_group("Timing")
@export var reset_after_time: bool = true
@export var reset_time: float = 3.0

@export_group("Reset")
@export var reset_target_on_timeout: bool = true
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
	triggered.emit(body)

	if anim_player and anim_player.has_animation("trigger"):
		anim_player.play("trigger")

	_apply_target_action(action)

	if reset_after_time:
		timer.start(reset_time)


func _on_timeout() -> void:
	reset.emit()

	if anim_player and anim_player.has_animation("reset"):
		anim_player.play("reset")

	if reset_target_on_timeout:
		_apply_target_action(_invert_action(action))

	if reusable:
		_used = false
	else:
		area.monitoring = false
		area.monitorable = false


func _invert_action(a: String) -> String:
	match a:
		"Open": return "Close"
		"Close": return "Open"
		"Toggle": return "Toggle"
		_: return a


func _apply_target_action(a: String) -> void:
	if target == null:
		return

	match a:
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
			if target.has_method("toggle_gate"):
				target.call_deferred("toggle_gate")
			elif ("is_open" in target
				and target.has_method("open_door")
				and target.has_method("close_door")):
				if target.is_open:
					target.call_deferred("close_door")
				else:
					target.call_deferred("open_door")
