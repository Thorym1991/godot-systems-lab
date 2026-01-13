extends CanvasLayer
class_name HUDPlayerStats

@export var player_path: NodePath

@onready var label_hp: Label = $MarginContainer/VBoxContainer/LabelHP
@onready var label_copper: Label = $MarginContainer/VBoxContainer/LabelCopper
@onready var label_lives: Label = $MarginContainer/VBoxContainer/LabelLives

var player: TopdownPlayer2D = null

func _ready() -> void:
	if player_path != NodePath():
		player = get_node_or_null(player_path) as TopdownPlayer2D
	else:
		# Fallback: erster Player in der Gruppe "player"
		var p := get_tree().get_first_node_in_group("player")
		player = p as TopdownPlayer2D

	if player == null:
		push_warning("HUDPlayerStats: Player not found. Set player_path or add player to group 'player'.")
		return

	# Health-Signals
	if player.health:
		player.health.hp_changed.connect(_on_hp_changed)

	# Initial refresh
	refresh_all()

func refresh_all() -> void:
	_refresh_hp()
	_refresh_copper()
	_refresh_lives()

func _on_hp_changed(_current: int, _max_hp: int, _delta: int, _source: Node) -> void:
	_refresh_hp()

func _refresh_hp() -> void:
	if player and player.health:
		label_hp.text = "HP: %d/%d" % [player.health.hp, player.health.max_hp]

func _refresh_copper() -> void:
	if player:
		label_copper.text = "Copper: %d" % player.money_copper

func _refresh_lives() -> void:
	if not player:
		return

	# Lives optional
	if ("lives_enabled" in player) and player.lives_enabled:
		label_lives.visible = true
		label_lives.text = "Lives: %d" % player.lives_left
	else:
		label_lives.visible = false
