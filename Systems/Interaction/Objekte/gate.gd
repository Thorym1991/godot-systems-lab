extends Node2D
class_name Gate

@onready var sprite: Sprite2D = $Sprite2D
@onready var block_collider: CollisionShape2D = $BlockBody/BlockCollider
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var is_open: bool = false

func open_gate() -> void:
	if is_open:
		return
	is_open = true
	# Collider aus → Weg frei
	block_collider.disabled = true

	# Entweder nur transparent machen:
	sprite.modulate.a = 0.0
	# oder Animation:
	if anim_player and anim_player.has_animation("open"):
		anim_player.play("open")


func close_gate() -> void:
	if not is_open:
		return
	is_open = false
	block_collider.disabled = false
	sprite.modulate.a = 1.0
	if anim_player and anim_player.has_animation("close"):
		anim_player.play("close")


func toggle_gate() -> void:
	if is_open:
		close_gate()
	else:
		open_gate()
