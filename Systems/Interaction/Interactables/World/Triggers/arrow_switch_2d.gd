extends Area2D
class_name ArrowSwitch2D

signal triggered

@export var one_shot: bool = true
@export var consume_projectile: bool = true
@export var target_door: NodePath

@export var sprite_off: Texture2D
@export var sprite_on: Texture2D

@onready var sprite: Sprite2D = $Sprite2D

var _used := false


func _ready() -> void:
	area_entered.connect(_on_area_entered)

	# Startzustand
	if sprite and sprite_off:
		sprite.texture = sprite_off


func _on_area_entered(a: Area2D) -> void:
	if _used and one_shot:
		return
	if not (a is Projectile2D):
		return

	var p := a as Projectile2D

	# Nur Player-Projektile
	var player_layer_bit := 1 << (12 - 1)
	if (p.collision_layer & player_layer_bit) == 0:
		return

	_used = true

	# Sprite wechseln
	if sprite and sprite_on:
		sprite.texture = sprite_on

	var door := get_node_or_null(target_door)
	if door and door.has_method("open_from_switch"):
			door.open_from_switch()


	triggered.emit()

	if consume_projectile:
		p.queue_free()
