extends Node
class_name EnemyStateMachine

var current: EnemyState
var states := {}
var enemy: CharacterBody2D

func setup(_owner: CharacterBody2D) -> void:
	owner = _owner
	for c in get_children():
		if c is EnemyState:
			c.machine = self
			c.enemy = owner
			states[c.id()] = c

func change(id: StringName) -> void:
	if current and current.id() == &"dead":
		return
	# rest...


	if current:
		current.exit()

	current = states.get(id)
	if current:
		print("[EnemySM] -> ", id)
		current.enter()


func physics_process(delta: float) -> void:
	if current:
		current.physics_process(delta)
