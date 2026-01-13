extends Node
class_name HealthComponent2D

signal hp_changed(current: int, max_hp: int, delta: int, source: Node)
signal died(source: Node)

@export var max_hp: int = 6
@export var start_full: bool = true
@export var invuln_time: float = 0.25

var hp: int = 0
var _invuln_left: float = 0.0
var _dead: bool = false

func _ready() -> void:
	hp = max_hp if start_full else maxi(1, max_hp)
	_dead = (hp <= 0)

func _process(delta: float) -> void:
	if _invuln_left > 0.0:
		_invuln_left = maxf(_invuln_left - delta, 0.0)

func is_dead() -> bool:
	return _dead

func can_take_damage() -> bool:
	return (not _dead) and (_invuln_left <= 0.0)

func heal(amount: int, source: Node = null) -> void:
	if _dead:
		return
	if amount <= 0:
		return

	var before: int = hp
	hp = mini(hp + amount, max_hp)
	var delta_hp: int = hp - before
	if delta_hp != 0:
		hp_changed.emit(hp, max_hp, delta_hp, source)

func take_damage(amount: int, source: Node = null) -> void:
	if amount <= 0:
		return
	if not can_take_damage():
		return

	var before: int = hp
	hp = maxi(hp - amount, 0)
	var delta_hp: int = hp - before # negativ
	hp_changed.emit(hp, max_hp, delta_hp, source)

	_invuln_left = invuln_time

	if hp <= 0 and not _dead:
		_dead = true
		died.emit(source)

func revive_full(source: Node = null) -> void:
	_dead = false
	_invuln_left = 0.0

	var before := hp
	hp = max_hp
	var delta_hp := hp - before
	if delta_hp != 0:
		hp_changed.emit(hp, max_hp, delta_hp, source)
