extends Interactable2D

signal chest_opened(chest: Node2D, interactor: Node, loot: Node)

@export var loot_scene: PackedScene          # optional – Item, Schlüssel, Rubin usw.
@export var open_animation: String = "open"  # AnimationName im AnimationPlayer
var is_open: bool = false

@onready var anim_player: AnimationPlayer = $AnimationPlayer


func interact(interactor: Node) -> void:
	if is_open:
		return  # Bereits geöffnet

	_open_chest(interactor)


func _open_chest(interactor: Node) -> void:
	is_open = true

	# Animation spielen
	if anim_player and anim_player.has_animation(open_animation):
		anim_player.play(open_animation)

	# Loot erzeugen (optional)
	var loot_instance: Node = null
	if loot_scene != null:
		loot_instance = loot_scene.instantiate()
		loot_instance.global_position = global_position
		get_tree().current_scene.add_child(loot_instance)

	# Signal senden, damit Inventar / UI reagieren kann
	emit_signal("chest_opened", self, interactor, loot_instance)
