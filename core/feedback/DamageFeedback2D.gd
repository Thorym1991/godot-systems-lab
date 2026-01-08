extends Node
class_name DamageFeedback2D

@export var sprite_path: NodePath
@export var lock_time: float = 0.10

@export var flash_times: int = 3
@export var flash_alpha: float = 0.2
@export var flash_step_time: float = 0.04

@export var hurt_sfx: StringName = &"hurt"
@export var hurt_sfx_volume_db: float = -6.0
@export var pitch_min: float = 0.95
@export var pitch_max: float = 1.05

@export var death_shake_intensity: float = 0.8
@export var death_shake_duration: float = 0.25

var _sprite: CanvasItem
var _flashing := false

func _ready() -> void:
	if sprite_path != NodePath(""):
		_sprite = get_node_or_null(sprite_path) as CanvasItem

func play_hurt() -> void:
	# SFX (wenn FeedbackBus als Autoload existiert)
	var bus := get_node_or_null("/root/feedbackBus") as feedbackBus
	if bus:
		bus.sfx_requested.emit(hurt_sfx, (owner as Node2D).global_position, hurt_sfx_volume_db, randf_range(pitch_min, pitch_max))

	_hurt_flash()

func play_death() -> void:
	var bus := get_node_or_null("/root/feedbackBus") as feedbackBus
	if bus:
		bus.shake_requested.emit(death_shake_intensity, death_shake_duration)

func request_input_lock() -> void:
	# setzt beim Owner (Player) _input_lock_left, falls vorhanden
	if owner and ("_input_lock_left" in owner):
		owner._input_lock_left = maxf(owner._input_lock_left, lock_time)

func _hurt_flash() -> void:
	if _sprite == null or _flashing:
		return
	_flashing = true

	for _i in range(flash_times):
		_sprite.modulate.a = flash_alpha
		await get_tree().create_timer(flash_step_time).timeout
		if not is_instance_valid(_sprite): break
		_sprite.modulate.a = 1.0
		await get_tree().create_timer(flash_step_time).timeout
		if not is_instance_valid(_sprite): break

	_flashing = false
