extends Area2D
class_name Hitbox2D

@export var base_damage: int = 1
@export var base_knockback: float = 140.0
@export var damage_type: StringName = &"physical"

var source: Node = null
var _swing_id: int = 0
var _hit_ids := {} # instance_id -> swing_id

func _ready() -> void:
	# Safety: Hitbox ist standardmäßig aus
	monitoring = false

func start_swing(new_source: Node) -> void:
	source = new_source
	_swing_id += 1
	monitoring = true
	print("HITBOX ON monitoring=", monitoring)


func end_swing() -> void:
	monitoring = false
	print("HITBOX OFF")


func can_hit(target: Node) -> bool:
	if target == null:
		return false
	var id := target.get_instance_id()
	return (not _hit_ids.has(id)) or (_hit_ids[id] != _swing_id)

func mark_hit(target: Node) -> void:
	if target == null:
		return
	_hit_ids[target.get_instance_id()] = _swing_id

func make_hit(dir: Vector2) -> HitData:
	var h := HitData.new()
	h.damage = base_damage
	h.knockback = base_knockback
	h.damage_type = damage_type
	h.dir = dir
	h.source = source
	return h
