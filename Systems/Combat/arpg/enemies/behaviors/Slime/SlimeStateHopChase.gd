extends EnemyState
class_name SlimeStateHopChase

# Gleiche ID wie generischer Chase
func id() -> StringName:
	return &"chase"

@export var hop_speed: float = 70.0
@export var hop_duration: float = 0.16
@export var windup_duration: float = 0.08
@export var pause_duration: float = 0.28
@export var min_distance: float = 6.0

# Pattern: 2 normale Hops, dann 1 großer
@export var big_hop_multiplier: float = 1.6
@export var big_hop_every: int = 3

# Friction / Feel
@export var stop_friction: float = 900.0

# Phasen:
# 0 = Pause
# 1 = Windup
# 2 = Hop
var _phase: int = 0
var _t_left: float = 0.0
var _hop_count: int = 0
var _hop_dir: Vector2 = Vector2.ZERO
var _current_mult: float = 1.0

func enter() -> void:
	_phase = 0
	_t_left = pause_duration
	enemy.velocity = Vector2.ZERO

func physics_process(delta: float) -> void:
	# Safety: falls Dead-State nicht hart locked
	if bool(enemy.get("is_dead")):
		return

	var active := bool(enemy.get("_active"))
	var target := enemy.get("_target") as Node2D
	if not active or target == null:
		machine.change(&"idle")
		return

	_t_left = maxf(_t_left - delta, 0.0)

	match _phase:
		0:
			# Pause
			enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, stop_friction * delta)
			enemy.move_and_slide()

			if _t_left <= 0.0:
				_prepare_hop(target)

		1:
			# Windup (steht still, ausholen)
			enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, stop_friction * delta)
			enemy.move_and_slide()

			if _t_left <= 0.0:
				_start_hop()

		2:
			# Hop
			enemy.velocity = _hop_dir * _get_speed() * _current_mult
			enemy.move_and_slide()

			if _t_left <= 0.0:
				# Hop endet → zurück in Pause
				_phase = 0
				_t_left = pause_duration
				enemy.velocity *= 0.2

func _prepare_hop(target: Node2D) -> void:
	var dir := (target.global_position - enemy.global_position)
	if dir.length() <= min_distance:
		_phase = 0
		_t_left = pause_duration
		return

	_hop_dir = dir.normalized()

	_hop_count += 1
	var is_big := (big_hop_every > 0 and (_hop_count % big_hop_every) == 0)
	_current_mult = big_hop_multiplier if is_big else 1.0

	_phase = 1
	_t_left = windup_duration

func _start_hop() -> void:
	_phase = 2
	_t_left = hop_duration

func _get_speed() -> float:
	var base := float(enemy.get("speed"))
	return maxf(base, hop_speed)
