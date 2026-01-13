extends Interactable2D
class_name Checkpoint2D

@export var one_time: bool = false
@export var sfx_name: StringName = &"checkpoint"

@onready var sprite: Sprite2D = $Sprite2D
@onready var glow: Sprite2D = $Sprite2D/Glow


var is_active: bool = false

func _ready() -> void:
	_update_visual()

func interact(interactor: Node) -> void:
	if one_time and is_active:
		return

	if interactor.has_method("set_checkpoint"):
		interactor.set_checkpoint(global_position, self)

	activate()

	feedbackBus.sfx_requested.emit(sfx_name, global_position, -6.0, randf_range(0.95, 1.05))


func _update_visual() -> void:
	if sprite:
		sprite.modulate = Color(1, 1, 1, 1) if is_active else Color(0.75, 0.75, 0.75, 1)

	if glow:
		glow.visible = is_active


func activate() -> void:
	is_active = true
	_update_visual()

func deactivate() -> void:
	is_active = false
	_update_visual()
