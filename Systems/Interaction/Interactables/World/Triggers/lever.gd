extends Interactable2D

signal lever_toggled(is_on: bool)

@export var target_gate: Gate
@onready var anim_player: AnimationPlayer = $AnimationPlayer


var is_on: bool = false

func interact(interactor: Node) -> void:
	_toggle()


func _toggle() -> void:
	is_on = !is_on

	if anim_player:
		var anim_name: String
		if is_on:
			anim_name = "on"
		else:
			anim_name = "off"

		if anim_player.has_animation(anim_name):
			anim_player.play(anim_name)

	emit_signal("lever_toggled", is_on)

	# Tor steuern, wenn eins verknüpft ist
	print("Lever toggled, target_gate =", target_gate)
	if target_gate and target_gate.has_method("toggle_gate"):
		print("Calling target_gate.toggle_gate()")
		target_gate.toggle_gate()
	else:
		print("NO valid target_gate or no toggle_gate() method!")
