extends Node
class_name EnemyState

var machine: EnemyStateMachine
var enemy: CharacterBody2D

func id() -> StringName:
	return &"base"

func enter() -> void: pass
func exit() -> void: pass
func physics_process(_delta: float) -> void: pass
