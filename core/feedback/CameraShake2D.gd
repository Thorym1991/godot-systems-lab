extends Camera2D
class_name CameraShake2D

var _shake_time := 0.0
var _shake_duration := 0.0
var _shake_intensity := 0.0

var _impulse_time := 0.0
var _impulse_duration := 0.0
var _impulse_dir := Vector2.ZERO
var _impulse_strength := 0.0

var _base_offset := Vector2.ZERO

func _ready() -> void:
	make_current() # erzwingt aktiv (nur zum Test)
	_base_offset = offset
	set_process(true)
	print("CameraShake READY")
	feedbackBus.shake_requested.connect(_on_shake)


func _process(delta: float) -> void:
	var o: Vector2 = _base_offset

	# impulse (quick kick)
	if _impulse_time < _impulse_duration:
		_impulse_time += delta
		var denom: float = max(_impulse_duration, 0.0001)
		var t: float = 1.0 - (_impulse_time / denom)
		o += _impulse_dir * (_impulse_strength * t)

	# shake (random jitter)
	if _shake_time < _shake_duration:
		_shake_time += delta
		var denom2: float = max(_shake_duration, 0.0001)
		var t2: float = 1.0 - (_shake_time / denom2)
		var amp: float = _shake_intensity * t2
		o += Vector2(randf_range(-amp, amp), randf_range(-amp, amp))

	offset = o


func _on_shake(intensity: float, duration: float) -> void:
	_shake_intensity = max(_shake_intensity, intensity)
	_shake_duration = max(_shake_duration, duration)
	_shake_time = 0.0

func _on_impulse(dir: Vector2, strength: float, duration: float) -> void:
	_impulse_dir = dir.normalized()
	_impulse_strength = strength
	_impulse_duration = duration
	_impulse_time = 0.0
