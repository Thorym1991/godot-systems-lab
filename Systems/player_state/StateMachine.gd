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
	if current and current.id() == to:
		return
	if not states.has(to):
		return

	var next: PlayerState = states[to]
	if next == current:
		return

	var old: PlayerState = current
	if old:
		old.exit(next)

	current = next
	current.enter(old)


func _enter(id: StringName) -> void:
	if not states.has(id):
		push_error("State '%s' not found in StateMachine" % id)
		return

	current = states[id]
	current.enter(null)
