extends Node
class_name StateMachine

@export var default_state: StringName = &"idle"
@export var character_body_path: NodePath = ^".."

var current: PlayerState
var character: CharacterBody2D
var states: Dictionary = {}


func _ready() -> void:
	character = get_node(character_body_path) as CharacterBody2D
	
	for child in get_children():
		if child is PlayerState:
			var id: StringName = child.id()
			child.machine = self
			child.character = character
			states[id] = child
	
	_enter(default_state)


func _physics_process(delta: float) -> void:
	if current:
		current.physics_update(delta)


func _unhandled_input(event: InputEvent) -> void:
	if current:
		current.input(event)


func change(to: StringName) -> void:
	if not states.has(to) or states[to] == current:
		return

	var old: PlayerState = current
	old.exit(states[to])
	current = states[to]
	current.enter(old)


func _enter(id: StringName) -> void:
	if not states.has(id):
		push_error("State '%s' not found in StateMachine" % id)
		return

	current = states[id]
	current.enter(null)
