extends Interactable2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var block_collider: CollisionShape2D = $Blockbody/BlockCollider
@export var player_interactable: bool = true


var is_open: bool = false

var is_locked: bool = false

func set_locked(v: bool) -> void:
	is_locked = v
	# optional: wenn lock = true, sicherheitshalber schließen
	if is_locked and is_open:
		close_door()

func interact(interactor: Node) -> void:
	if is_locked:
		return
	if not player_interactable:
		return
	if is_open:
		close_door()
	else:
		open_door()




func open_door() -> void:
	is_open = true
	feedbackBus.sfx_requested.emit(&"dooropen", global_position, -2.0, randf_range(0.95, 1.05))

	# Sichtbarkeit ist okay sofort
	sprite.modulate.a = 0.0

	# Physics-Änderung deferred!
	if block_collider:
		block_collider.set_deferred("disabled", true)


func close_door() -> void:
	is_open = false
	feedbackBus.sfx_requested.emit(&"doorclose", global_position, -2.0, randf_range(0.95, 1.05))

	sprite.modulate.a = 1.0

	if block_collider:
		block_collider.set_deferred("disabled", false)


func open_from_switch() -> void:
	# Schalter soll die Tür öffnen, unabhängig von player_interactable
	if is_open:
		return
	open_door()

func close_from_switch() -> void:
	if not is_open:
		return
	close_door()

func set_open(v: bool) -> void:
	if v:
		open_from_switch()
	else:
		close_from_switch()
