extends Node2D
class_name PressurePlate

signal activated
signal deactivated

@export var only_player: bool = false  # false = Player + andere Bodies erlaubt
@export var required_bodies: int = 1   # z.B. 2 = Player + Block

@export var target_gate: Gate
@export_enum("Open", "Close", "Toggle") var on_activate := "Open"
@export_enum("Open", "Close", "Toggle") var on_deactivate := "Close"

@export var use_animation: bool = true
@export var pressed_anim: String = "pressed"
@export var released_anim: String = "released"

@onready var area: Area2D = $Area2D
@onready var anim_player: AnimationPlayer = get_node_or_null("AnimationPlayer")

var _bodies := {}      # Dictionary als Set: instance_id -> true
var is_active := false


func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node) -> void:
	if not _accept_body(body):
		print("PLATE ENTER:", body.name, " layer=", (body as CollisionObject2D).collision_layer if body is CollisionObject2D else "n/a")
		return

	_bodies[body.get_instance_id()] = true
	_update_state()


func _on_body_exited(body: Node) -> void:
	var id := body.get_instance_id()
	if _bodies.has(id):
		_bodies.erase(id)
	_update_state()


func _accept_body(body: Node) -> bool:
	# Wenn nur Player zählen soll:
	if only_player:
		return body.is_in_group("player")

	# Sonst: Player oder pushable (für Blöcke später) oder generell jedes PhysicsBody2D
	# -> Ich empfehle trotzdem Gruppen für Kontrolle:
	if body.is_in_group("player"):
		return true
	if body.is_in_group("pushable"):
		return true
	if body.is_in_group("movable"):
		return true

	# Falls du erstmal ALLES zählen willst, kannst du hier auch einfach `return true` machen.
	return false


func _update_state() -> void:
	var count := _bodies.size()

	if not is_active and count >= required_bodies:
		_activate()
	elif is_active and count < required_bodies:
		_deactivate()


func _activate() -> void:
	is_active = true
	emit_signal("activated")

	if use_animation and anim_player and anim_player.has_animation(pressed_anim):
		anim_player.play(pressed_anim)

	_apply_gate_action(on_activate)


func _deactivate() -> void:
	is_active = false
	emit_signal("deactivated")

	if use_animation and anim_player and anim_player.has_animation(released_anim):
		anim_player.play(released_anim)

	_apply_gate_action(on_deactivate)


func _apply_gate_action(action: String) -> void:
	if not target_gate:
		return

	match action:
		"Open":
			target_gate.open_gate()
		"Close":
			target_gate.close_gate()
		"Toggle":
			target_gate.toggle_gate()
