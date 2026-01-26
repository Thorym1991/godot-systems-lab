extends EnemyState
class_name EnemyStateHide

@export var hide_time: float = 1.0

func id() -> StringName:
	return &"hide"

func enter() -> void:
	if enemy.has_method("set_vulnerable"):
		enemy.set_vulnerable(false)
	_set_visible(false)

	await get_tree().create_timer(hide_time).timeout

	if enemy.has_method("has_target") and enemy.has_target():
		machine.change(&"emerge")
	# else: bleiben, KEIN change("hide")


func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass

func _set_visible(v: bool) -> void:
	if enemy.has_method("set_visible_state"):
		enemy.set_visible_state(v)
		return

	var sprite := enemy.get_node_or_null("Sprite2D") as CanvasItem
	if sprite:
		sprite.visible = v
