extends Node2D
class_name LootDropper2D

@export var loot_scene: PackedScene            # z. B. LootPickup2D.tscn
@export var items: Array[ItemData] = []        # mögliche Drops
@export var weights: Array[int] = []           # Gewichtung (optional)
@export var drop_chance: float = 0.5            # 0.0–1.0
@export var min_amount: int = 1
@export var max_amount: int = 1
@export var scatter_radius: float = 10.0
@export var scatter_impulse: float = 0.0 # optional, erstmal 0 lassen
@export var drops_per_trigger_min: int = 1
@export var drops_per_trigger_max: int = 1



func drop(position: Vector2) -> void:
	call_deferred("_drop_deferred", position)

func _drop_deferred(position: Vector2) -> void:
	if loot_scene == null:
		return
	if items.is_empty():
		return
	if randf() > drop_chance:
		return

	var drop_count := randi_range(drops_per_trigger_min, drops_per_trigger_max)

	for _i in range(drop_count):
		var item := _pick_weighted_item()
		if item == null:
			continue

		var loot := loot_scene.instantiate() as LootPickup2D
		loot.item = item
		loot.amount = randi_range(min_amount, max_amount)

		get_tree().current_scene.add_child(loot)

		# Scatter nutzt jetzt scatter_radius
		loot.global_position = position + Vector2(
			randf_range(-scatter_radius, scatter_radius),
			randf_range(-scatter_radius, scatter_radius)
		)


func _pick_weighted_item() -> ItemData:
	if weights.size() != items.size():
		return items.pick_random()

	var total: int = 0
	for w in weights:
		total += maxi(w, 0)

	var denom: int = maxi(total, 1)
	var r: int = randi() % denom

	var acc: int = 0
	for i in range(items.size()):
		acc += maxi(weights[i], 0)
		if r < acc:
			return items[i]

	return items[0]
