extends Node
class_name AudioManager

@export var library: AudioLibrary
@export var max_players: int = 16
@export var sfx_bus_name: StringName = &"SFX"

var _players: Array[AudioStreamPlayer2D] = []

func _ready() -> void:
	feedbackBus.sfx_requested.connect(_on_sfx_requested)

	# Fallback: Standard-Library laden
	if library == null:
		library = load("res://core/audio/default_audio_library.tres") as AudioLibrary

	for i in range(max_players):
		var p := AudioStreamPlayer2D.new()
		p.bus = String(sfx_bus_name)
		add_child(p)
		_players.append(p)

func _on_sfx_requested(name: StringName, pos: Vector2, volume_db: float, pitch: float) -> void:
	if library == null:
		push_warning("AudioManager: no AudioLibrary assigned")
		return

	var stream: AudioStream = library.sounds.get(name) as AudioStream
	if stream == null:
		push_warning("AudioManager: missing sfx '" + String(name) + "'")
		return

	var p := _get_free_player()
	p.stream = stream
	p.global_position = pos
	p.volume_db = volume_db
	p.pitch_scale = pitch
	p.play()

func _get_free_player() -> AudioStreamPlayer2D:
	for p in _players:
		if not p.playing:
			return p
	return _players[0]
