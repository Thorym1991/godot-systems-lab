extends Node
class_name TorchDoorPuzzle2D

@export_group("Wiring")
@export var torches: Array[NodePath] = []   # TorchStand2D Nodes
@export var door_path: NodePath             # Door Node (dein Door/ToggleDoor)

@export_group("Rules")
@export var require_all_lit: bool = true    # true = alle müssen an sein
@export var auto_close: bool = false        # wenn false: Tür bleibt nach Öffnen offen

var _torch_nodes: Array[Node] = []
var _door: Node = null
var _opened_once: bool = false

func _ready() -> void:
	_door = get_node_or_null(door_path)
	if _door == null:
		push_error("TorchDoorPuzzle2D: door_path ist ungültig.")
		return

	# Torches auflösen + Signal verbinden
	for p in torches:
		var t := get_node_or_null(p)
		if t == null:
			push_error("TorchDoorPuzzle2D: Torch NodePath ungültig: %s" % str(p))
			continue
		_torch_nodes.append(t)

		if t.has_signal("lit_changed"):
			# Godot 4 Callable style
			t.connect("lit_changed", Callable(self, "_on_torch_lit_changed"))
		else:
			push_error("TorchDoorPuzzle2D: Torch hat kein Signal lit_changed: %s" % t.name)

	_evaluate()

func _on_torch_lit_changed(_is_lit: bool) -> void:
	_evaluate()

func _evaluate() -> void:
	if _torch_nodes.is_empty():
		return

	var lit_count := 0
	for t in _torch_nodes:
		if ("is_lit" in t) and t.is_lit:
			lit_count += 1

	var solved := false
	if require_all_lit:
		solved = (lit_count == _torch_nodes.size())
	else:
		solved = (lit_count > 0)

	if solved:
		_open_door()
	else:
		if auto_close:
			_close_door()

func _open_door() -> void:
	if _opened_once and not auto_close:
		return
	_opened_once = true

	# Unterstützt verschiedene Door-APIs
	if _door.has_method("open_door"):
		_door.call_deferred("open_door")
	elif _door.has_method("open"):
		_door.call("open")
	elif ("is_open" in _door) and _door.has_method("interact"):
		# als Fallback togglen wir
		if not _door.is_open:
			_door.call("interact", self)
	else:
		push_error("TorchDoorPuzzle2D: Door hat keine bekannte Open-Methode.")

func _close_door() -> void:
	if _door.has_method("close_door"):
		_door.call("close_door")
	elif _door.has_method("close"):
		_door.call("close")
	elif ("is_open" in _door) and _door.has_method("interact"):
		if _door.is_open:
			_door.call("interact", self)
