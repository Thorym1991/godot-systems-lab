extends Area2D

@export var boss_controller_path: NodePath

var _fired := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if _fired:
		return
	
	# Option A: über Gruppe
	if body.is_in_group("player"):
		_fired = true
		get_node(boss_controller_path).start_phase_1()
		return

	# Option B: über Typ (falls du keine Gruppe nutzt)
	# if body is TopdownPlayer2D:
	#   _fired = true
	#   get_node(boss_controller_path).start_phase_1()
