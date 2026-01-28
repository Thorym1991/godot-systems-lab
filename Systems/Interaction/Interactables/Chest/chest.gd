extends Interactable2D
class_name Chest2D

signal chest_opened(chest: Node2D, interactor: Node, loot: Node)

@export var loot_scene: PackedScene          # optional – Item, Schlüssel, Rubin usw.
@export var open_animation: String = "open"  # AnimationName im AnimationPlayer

# Dungeon/Progression (optional)
@export var gives_flag: StringName = &""     # z.B. &"bow_unlocked"
@export var one_time: bool = true
@export var spawn_loot_in_world: bool = true # false = loot nicht spawnen (nur Signal/Flag)
@export var reward_icon: Texture2D
@export var popup_scene: PackedScene


var is_open: bool = false

@onready var anim_player: AnimationPlayer = $AnimationPlayer


func interact(interactor: Node) -> void:
	if one_time and is_open:
		return
	_open_chest(interactor)


func _open_chest(interactor: Node) -> void:
	is_open = true

	if anim_player and anim_player.has_animation(open_animation):
		anim_player.play(open_animation)

	_spawn_popup()

	# Flag (optional)
	if gives_flag != &"":
		if Engine.has_singleton("progress_store"):
			progressStore.set_flag(gives_flag, true)

	# Loot (optional)
	var loot_instance: Node = null
	if loot_scene != null:
		loot_instance = loot_scene.instantiate()
		if spawn_loot_in_world and loot_instance is Node2D:
			(loot_instance as Node2D).global_position = global_position
			get_tree().current_scene.add_child(loot_instance)

	emit_signal("chest_opened", self, interactor, loot_instance)


func _spawn_popup() -> void:
	if popup_scene == null:
		push_warning("Chest: popup_scene is null (Inspector gesetzt?)")
		return
	if reward_icon == null:
		push_warning("Chest: reward_icon is null (Inspector gesetzt?)")
		return

	var inst := popup_scene.instantiate()
	if inst == null:
		push_warning("Chest: popup_scene.instantiate() returned null")
		return

	if not (inst is Node2D):
		push_warning("Chest: popup root is not Node2D")
		inst.queue_free()
		return

	var pop := inst as Node2D
	get_tree().current_scene.add_child(pop)
	pop.global_position = global_position + Vector2(0, -20)

	if pop.has_method("setup"):
		pop.call("setup", reward_icon)
