extends CharacterBody2D
class_name FrameworkPlayer2D

@export var speed := 200.0
@export var gravity := 900.0
@export var jump_force :=1000.0

@onready var machine: StateMachine =$StateMachine

func apply_gravity(delta: float):
	if !is_on_floor():
		velocity.y += gravity * delta

func move_x(dir: float):
	velocity.x = dir * speed
	
func jump():
	velocity.y -= jump_force

func _physics_process(delta: float):
	move_and_slide()
