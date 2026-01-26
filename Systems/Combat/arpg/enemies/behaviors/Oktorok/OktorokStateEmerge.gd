extends EnemyState
class_name EnemyStateEmerge

@export var emerge_time: float = 0.35
@export var become_vulnerable_on_enter: bool = true


func id() -> StringName:
	return &"emerge"

func enter() -> void:
	# 1) Sichtbar machen
	_set_visible(true)

	# 2) Optional: direkt verwundbar (oder erst in shoot, je nach Design)
	if become_vulnerable_on_enter and enemy.has_method("set_vulnerable"):
		enemy.set_vulnerable(true)

	# 3) Kurzer Telegraph / Auftauch-Delay
	await get_tree().create_timer(emerge_time).timeout

	# 4) Weiter zum Schuss
	machine.change(&"shoot")

func exit() -> void:
	pass

func physics_process(_delta: float) -> void:
	pass

func _set_visible(v: bool) -> void:
	# Variante A: Enemy hat eigene Helper-Methode
	if enemy.has_method("set_visible_state"):
		enemy.set_visible_state(v)
		return

	# Variante B: Standard: Sprite2D direkt togglen (passen NodePath ggf. an)
	var sprite := enemy.get_node_or_null("Sprite2D") as CanvasItem
	if sprite:
		sprite.visible = v
