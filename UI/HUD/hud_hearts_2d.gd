extends CanvasLayer
class_name HUDHearts2D

@export var player_path: NodePath

@export var heart_full: Texture2D
@export var heart_empty: Texture2D
@export var hp_per_heart: int = 1 # später easy auf 2 umstellen für Half-Hearts

@onready var hearts_row: HBoxContainer = $MarginContainer/HeartsRow

var player: TopdownPlayer2D
var _last_max_hp := -1
var _heart_sprites: Array[TextureRect] = []

func _ready() -> void:
	add_to_group("hud_player_stats") # optional, falls du weiter refresh_all nutzt

	player = _resolve_player()
	if player == null:
		push_warning("HUDHearts2D: Player not found.")
		return

	if player.health:
		player.health.hp_changed.connect(_on_hp_changed)

	_rebuild_if_needed()
	_refresh()

func refresh_all() -> void:
	_rebuild_if_needed()
	_refresh()

func _resolve_player() -> TopdownPlayer2D:
	if player_path != NodePath():
		return get_node_or_null(player_path) as TopdownPlayer2D
	var p := get_tree().get_first_node_in_group("player")
	return p as TopdownPlayer2D

func _on_hp_changed(_current: int, _max_hp: int, _delta: int, _source: Node) -> void:
	_rebuild_if_needed()
	_refresh()

func _rebuild_if_needed() -> void:
	if player == null or player.health == null:
		return

	var max_hp := player.health.max_hp
	if max_hp == _last_max_hp:
		return

	_last_max_hp = max_hp

	# clear old
	for c in hearts_row.get_children():
		c.queue_free()
	_heart_sprites.clear()

	var heart_count := int(ceil(float(max_hp) / float(hp_per_heart)))

	for i in heart_count:
		var tr := TextureRect.new()
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr.custom_minimum_size = Vector2(24, 24) # nach Geschmack
		hearts_row.add_child(tr)
		_heart_sprites.append(tr)

func _refresh() -> void:
	if player == null or player.health == null:
		return

	var hp := player.health.hp
	for i in _heart_sprites.size():
		var heart_hp_start := i * hp_per_heart
		var filled := hp > heart_hp_start
		_heart_sprites[i].texture = heart_full if filled else heart_empty
