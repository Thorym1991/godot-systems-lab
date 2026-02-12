extends Node2D
class_name PaintingSlot2D

@export var scene_arm: PackedScene
@export var scene_spikes: PackedScene
@export var scene_void_pull: PackedScene


var active: bool = true
var broken: bool = false
var ability_name: StringName = &"arm"

@onready var anim: AnimatedSprite2D = $PaintingAnim
@onready var ability_anchor: Node2D = $AbilityAnchor
var ability_instance: Node = null

func set_active(v: bool) -> void:
	active = v
	if not broken:
		anim.play("idle")

func set_ability(name: StringName) -> void:
	ability_name = name
	
	# Alte Ability entfernen
	if ability_instance:
		ability_instance.queue_free()
		ability_instance = null

	var scene: PackedScene = null
	
	match ability_name:
		&"arm":
			scene = scene_arm
		&"spikes":
			scene = scene_spikes
		&"void_pull":
			scene = scene_void_pull
	
	if scene:
		ability_instance = scene.instantiate()
		ability_anchor.add_child(ability_instance)


func play_warning() -> void:
	if not active or broken:
		return
	anim.play("warn_" + String(ability_name))

func execute() -> void:
	if not active or broken:
		return
	
	if anim:
		anim.play("idle")
	
	if ability_instance and ability_instance.has_method("execute"):
		ability_instance.execute()


func set_broken(v: bool) -> void:
	broken = v
	if broken:
		active = false
		anim.play("dead")
	else:
		anim.play("idle")

func get_warning_finished() -> Signal:
	return anim.animation_finished



	var scene: PackedScene = null
	
	match ability_name:
		&"arm":
			scene = scene_arm
		&"spikes":
			scene = scene_spikes
		&"void_pull":
			scene = scene_void_pull
	
	if scene:
		ability_instance = scene.instantiate()
		ability_anchor.add_child(ability_instance)
