extends Node2D
class_name InteractionManager2D
## Handles detection of nearby Interactable2D nodes and triggering interactions.
## Intended to be used as a child of the player character.

@export var detection_area_path: NodePath = ^"DetectionArea"
## Area2D used to detect interactables around the player.

@export var prompt_ui_path: NodePath
## Optional: Node that will display the current prompt text (e.g. Label).
## Can be left empty if you don't want UI yet.

var _detection_area: Area2D
var _prompt_ui: Node

var _candidates: Array[Interactable2D] = []
var _current: Interactable2D


func _ready() -> void:
	# Get detection area
	_detection_area = get_node_or_null(detection_area_path)
	if _detection_area == null:
		return

	_detection_area.area_entered.connect(_on_area_entered)
	_detection_area.area_exited.connect(_on_area_exited)

	# Optional prompt UI
	if prompt_ui_path != NodePath(""):
		_prompt_ui = get_node_or_null(prompt_ui_path)

	_update_prompt()


func _on_area_entered(area: Area2D) -> void:
	if area is Interactable2D:
		_candidates.append(area)
		_update_current()


func _on_area_exited(area: Area2D) -> void:
	if area is Interactable2D:
		_candidates.erase(area)
		if area == _current:
			_current = null
		_update_current()


func _update_current() -> void:
	## Pick the closest interactable to the player from all candidates.
	if _candidates.is_empty():
		_current = null
		_update_prompt()
		return

	var owner_node := owner as Node2D
	if owner_node == null:
		_current = _candidates[0]
		_update_prompt()
		return

	var best: Interactable2D = _candidates[0]
	var best_dist := owner_node.global_position.distance_to(best.global_position)

	for candidate in _candidates:
		var dist := owner_node.global_position.distance_to(candidate.global_position)
		if dist < best_dist:
			best = candidate
			best_dist = dist

	_current = best
	_update_prompt()


func _unhandled_input(event: InputEvent) -> void:
	var p := owner as TopdownPlayer2D
	if p == null:
		return

	# ⛔ Wenn tot: keinerlei Interactions
	if p.is_dead:
		return

	# ⛔ Während Grab kein Interact erlauben
	if p.is_grabbing():
		return

	# ⛔ Während Carry kein neues Interact erlauben
	if p.carried != null:
		return

	if event.is_action_pressed("interact") and _current:
		_current.interact(p)


func _update_prompt() -> void:
	if _prompt_ui == null:
		return

	var p := owner as TopdownPlayer2D
	if p == null:
		_prompt_ui.visible = false
		return

	# ⛔ Wenn tot: Prompt aus
	if p.is_dead:
		_prompt_ui.visible = false
		return

	# ⛔ Während Grab oder Carry keinen Interact-Prompt anzeigen
	if p.is_grabbing() or p.carried != null:
		_prompt_ui.visible = false
		return

	# Normaler Interact-Prompt
	if _current:
		if _prompt_ui is Label:
			(_prompt_ui as Label).text = _current.prompt_text
		_prompt_ui.visible = true
	else:
		_prompt_ui.visible = false
