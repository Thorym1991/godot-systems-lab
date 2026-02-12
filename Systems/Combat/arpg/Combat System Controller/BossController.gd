extends Node
class_name PaintingBossController

@export var paintings_root: NodePath = ^"../BossPaintings"
@export var cooldown_time := 1.1

var slots: Array[PaintingSlot2D] = []
var last_slot: PaintingSlot2D = null
var phase_active := false

var abilities: Array[StringName] = [&"arm", &"spikes", &"voidpull"]

func _ready() -> void:
	slots.clear()
	for c in get_node(paintings_root).get_children():
		var s := c as PaintingSlot2D
		if s != null:
			slots.append(s)

	_assign_phase_mapping()

func start_phase_1() -> void:
	if phase_active:
		return
	phase_active = true
	_attack_loop()

func stop_phase() -> void:
	phase_active = false

func _assign_phase_mapping() -> void:
	for s in slots:
		s.set_active(true)
		s.set_ability(abilities.pick_random())

func _attack_loop() -> void:
	while phase_active:
		var slot: PaintingSlot2D = _pick_next_slot()
		if slot == null:
			await get_tree().create_timer(0.2).timeout
			continue

		slot.play_warning()
		await slot.get_warning_finished()

		slot.execute()
		await get_tree().create_timer(cooldown_time).timeout

func _pick_next_slot() -> PaintingSlot2D:
	if slots.is_empty():
		return null

	var slot: PaintingSlot2D = slots.pick_random() as PaintingSlot2D
	if last_slot != null and slots.size() > 1:
		while slot == last_slot:
			slot = slots.pick_random() as PaintingSlot2D

	last_slot = slot
	return slot
