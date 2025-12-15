extends CharacterBody2D
class_name GrabBlock2D

@export var push_speed: float = 70.0
@export var interactable_path: NodePath

@onready var interactable: Interactable2D = null

var grabber: CharacterBody2D = null

func _ready() -> void:
	# Interactable finden (Path oder Fallback)
	if interactable_path != NodePath(""):
		interactable = get_node_or_null(interactable_path) as Interactable2D

	if interactable == null:
		for c in get_children():
			if c is Interactable2D:
				interactable = c
				break

	if interactable == null:
		push_error("GrabBlock2D: Kein Interactable2D gefunden. Setze interactable_path oder füge Interactable2D als Kind hinzu.")
		return

	interactable.interaction_started.connect(_on_interaction)
	_update_prompt()

func _on_interaction(interactor: Node) -> void:
	print("[GrabBlock] interaction_started von:", interactor.name)

	if not (interactor is CharacterBody2D):
		print("[GrabBlock] Interactor ist kein CharacterBody2D")
		return

	var player := interactor as CharacterBody2D

	# Toggle: Grab / Release
	if grabber == player:
		_release_from(player)
	else:
		_grab_from(player)

func _grab_from(player: CharacterBody2D) -> void:
	grabber = player
	print("[GrabBlock] grabbed by", player.name)

	# Player merken lassen
	if player.has_method("set_grabbed_block"):
		player.call("set_grabbed_block", self)

	# Player blockiert sonst die Block-Bewegung
	add_collision_exception_with(player)
	player.add_collision_exception_with(self)

	_update_prompt()


func _release_from(player: CharacterBody2D) -> void:
	if grabber != player:
		return

	grabber = null
	velocity = Vector2.ZERO

	if player.has_method("set_grabbed_block"):
		player.call("set_grabbed_block", null)
	remove_collision_exception_with(player)
	player.remove_collision_exception_with(self)
	_update_prompt()

func release() -> void:
	if grabber:
		_release_from(grabber)

func is_grabbed() -> bool:
	return grabber != null

# Wird vom Grab-State aufgerufen (Zelda Push)
# Gibt zurück, wie weit der Block wirklich kam.
func push(dir: Vector2, delta: float) -> Vector2:
	if grabber == null:
		return Vector2.ZERO

	if dir == Vector2.ZERO:
		return Vector2.ZERO

	var before := global_position
	var motion := dir.normalized() * push_speed * delta

	move_and_collide(motion)  # <- einfacher & stabil für Topdown push

	var moved := global_position - before
	print("[GrabBlock] moved =", moved)
	return moved


func _update_prompt() -> void:
	if interactable == null:
		return

	if grabber != null:
		interactable.prompt_text = "Release"
	else:
		interactable.prompt_text = "Grab"
