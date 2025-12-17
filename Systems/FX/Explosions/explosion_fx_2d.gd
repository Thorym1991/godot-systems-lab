extends Node2D
class_name ExplosionFX2D

@export var animation_name: StringName = &"explosion"
@export var fallback_lifetime := 0.7

@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if anim and anim.has_animation(animation_name):
		if has_node("Sprite2D"):
			$Sprite2D.frame = 0   # 🔑 WICHTIG
			$Sprite2D.visible = true

		anim.play(animation_name)

		var len := anim.get_animation(animation_name).length
		await get_tree().create_timer(len).timeout
		queue_free()
	else:
		await get_tree().create_timer(fallback_lifetime).timeout
		queue_free()
