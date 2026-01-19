extends PlayerState

@export var attack_duration := 0.30
@export var hit_start := 0.06
@export var hit_end := 0.16

var _t := 0.0
var _hit_on := false
var _started := false

func id() -> StringName:
	return &"attack"

func enter(_previous: PlayerState) -> void:
	# Wenn enter irgendwie doppelt kommt: ignorieren
	if _started:
		return

	_started = true
	_t = 0.0
	_hit_on = false

	var p := character as TopdownPlayer2D
	if p:
		p.sword_swing_end()

func physics_update(delta: float) -> void:
	_t += delta
	var p := character as TopdownPlayer2D
	if p == null:
		return

	if (not _hit_on) and _t >= hit_start:
		_hit_on = true
		p.sword_swing_start()

	if _hit_on and _t >= hit_end:
		_hit_on = false
		p.sword_swing_end()

	if _t >= attack_duration:
		machine.change(&"idle")

func exit(_next: PlayerState) -> void:
	var p := character as TopdownPlayer2D
	if p:
		p.sword_swing_end()
	_started = false
