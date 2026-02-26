extends Node2D
class_name PaintingAbilitySpikes

@export var spike_scene: PackedScene

# ---- Lane selection ----
# Fallback-Gruppe, falls lane_groups leer ist
@export var group_name: StringName = &"lane_h"

# Trage hier deine Lane-Gruppen ein, z.B. lane_h_0..lane_h_3
@export var lane_groups: Array[StringName] = []
@export var avoid_same_lane_twice: bool = true
var _last_lane_idx: int = -1

# ---- Spawn tuning ----
@export var max_spawn: int = 90
@export var mode: StringName = &"wave" # "wave" oder "burst"
@export var wave_delay: float = 0.06
@export var batch_size: int = 1

# ---- Order tuning (für echte Waves wichtig) ----
@export var sort_mode: StringName = &"none" # none, x, y, diag_a, diag_b
@export var reverse: bool = false


func _ready() -> void:
	# sorgt dafür, dass randi() wirklich "zufällig" ist
	randomize()


func execute() -> void:
	if spike_scene == null:
		push_error("PaintingAbilitySpikes: spike_scene not set")
		return

	# ✅ Lane-Gruppe wählen (zufällig)
	var chosen_group: StringName = _pick_lane_group()

	# ✅ Jetzt ist get_tree() safe (Node hängt im Tree)
	var points: Array[Node2D] = _get_points_from_group(chosen_group)

	if points.is_empty():
		push_warning("PaintingAbilitySpikes: no spike slots in group: " + String(chosen_group))
		return

	_sort_points(points)

	# Limit
	var count: int = min(max_spawn, points.size())
	if count <= 0:
		return

	# Spawn
	if mode == &"burst":
		for i in range(count):
			_spawn_one(points[i].global_position)
	else:
		await _spawn_wave(points, count)


# ----------------------------
# Lane selection
# ----------------------------

func _pick_lane_group() -> StringName:
	if lane_groups.is_empty():
		return group_name

	var idx := randi() % lane_groups.size()

	if avoid_same_lane_twice and lane_groups.size() > 1:
		while idx == _last_lane_idx:
			idx = randi() % lane_groups.size()

	_last_lane_idx = idx
	return lane_groups[idx]


# ----------------------------
# Helpers
# ----------------------------

func _get_points_from_group(g: StringName) -> Array[Node2D]:
	var nodes: Array[Node] = get_tree().get_nodes_in_group(String(g))

	# Duplikat-Schutz (wenn Slots mehrere Gruppen haben)
	var unique := {}
	var out: Array[Node2D] = []
	out.resize(0)

	for n in nodes:
		if unique.has(n):
			continue
		unique[n] = true

		var p := n as Node2D
		if p != null:
			out.append(p)

	if reverse:
		out.reverse()

	return out


func _sort_points(points: Array[Node2D]) -> void:
	match sort_mode:
		&"x":
			points.sort_custom(func(a: Node2D, b: Node2D) -> bool:
				return a.global_position.x < b.global_position.x
			)
		&"y":
			points.sort_custom(func(a: Node2D, b: Node2D) -> bool:
				return a.global_position.y < b.global_position.y
			)
		&"diag_a":
			# ↘ sort by (x+y)
			points.sort_custom(func(a: Node2D, b: Node2D) -> bool:
				return (a.global_position.x + a.global_position.y) < (b.global_position.x + b.global_position.y)
			)
		&"diag_b":
			# ↙ sort by (x - y)
			points.sort_custom(func(a: Node2D, b: Node2D) -> bool:
				return (a.global_position.x - a.global_position.y) < (b.global_position.x - b.global_position.y)
			)
		_:
			# none
			pass


func _spawn_one(pos: Vector2) -> void:
	var spike := spike_scene.instantiate() as Node2D
	if spike == null:
		return
	spike.global_position = pos
	get_tree().current_scene.add_child(spike)


func _spawn_wave(points: Array[Node2D], count: int) -> void:
	var b: int = batch_size
	if b < 1:
		b = 1

	var i: int = 0
	while i < count:
		var spawned: int = 0
		while spawned < b and i < count:
			_spawn_one(points[i].global_position)
			i += 1
			spawned += 1

		await get_tree().create_timer(wave_delay).timeout
