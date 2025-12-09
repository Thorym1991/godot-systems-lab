extends CharacterBody2D


class_name TopdownPlayer2D

@export var speed: float = 150.0

func move_dir(dir: Vector2) -> void:
	velocity = dir * speed

func _physics_process(delta: float) -> void:
	move_and_slide()
