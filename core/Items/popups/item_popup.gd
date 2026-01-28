extends Node2D
class_name ItemPopup2D

@export var life_time: float = 1.2
@export var rise: float = 18.0

@onready var sprite: Sprite2D = $Sprite2D
var _t := 0.0
var _start_global := Vector2.ZERO

func setup(tex: Texture2D) -> void:
	sprite.texture = tex

func _ready() -> void:
	# WICHTIG: erst 1 Frame warten, damit die Chest-Position sicher gesetzt ist
	await get_tree().process_frame
	_start_global = global_position

func _process(delta: float) -> void:
	_t += delta
	var k := clampf(_t / life_time, 0.0, 1.0)

	global_position = _start_global + Vector2(0, -rise * k)

	if _t >= life_time:
		queue_free()
