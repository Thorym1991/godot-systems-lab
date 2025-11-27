extends Node
class_name PlayerState

var character: CharacterBody2D
var machine: Node

func enter(previous: PlayerState) -> void: 
	pass

func exit(next: PlayerState) -> void: 
	pass

func physics_update(delta: float) -> void: 
	pass

func input(event: InputEvent) -> void: 
	pass

func id() -> StringName:
	return &"base"
