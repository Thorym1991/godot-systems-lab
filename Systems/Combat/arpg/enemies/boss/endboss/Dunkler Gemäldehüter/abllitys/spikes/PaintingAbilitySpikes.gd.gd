extends Node2D
class_name PaintingAbilitySpikes

@export var spike_scene: PackedScene

var slots_root: Node = null
var slots: Array[SpikeSlot2D] = []

func set_slots_root(root: Node) -> void:
	slots_root = root
	_collect_slots()

func _collect_slots() -> void:
	slots.clear()
	if slots_root == null:
		return

	for c in slots_root.get_children():
		var s := c as SpikeSlot2D
		if s != null and s.enabled:
			slots.append(s)

func execute() -> void:
	if spike_scene == null:
		push_error("PaintingAbilitySpikes: spike_scene not set")
		return
	if slots.is_empty():
		push_warning("PaintingAbilitySpikes: no spike slots")
		return

	slots.shuffle()
	var count: int = min(8, slots.size())

	for i in range(count):
		var spike := spike_scene.instantiate() as Node2D
		spike.global_position = slots[i].global_position
		get_tree().current_scene.add_child(spike)
