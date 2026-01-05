extends CharacterBody2D
class_name TopdownPlayer2D

@export var speed: float = 150.0

var grabbed_block: GrabBlock2D = null
var input_dir: Vector2 = Vector2.ZERO
var carried: Carryable2D = null


func _physics_process(delta: float) -> void:
	# NUR Input sammeln – KEINE Bewegung!
	input_dir = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)


func set_grabbed_block(b: GrabBlock2D) -> void:
	grabbed_block = b

func get_grabbed_block() -> GrabBlock2D:
	return grabbed_block

func is_grabbing() -> bool:
	return grabbed_block != null and grabbed_block.grabber == self

func release_grab() -> void:
	if grabbed_block:
		grabbed_block.release()
	grabbed_block = null

func start_grab(b: GrabBlock2D) -> void:
	grabbed_block = b
	$StateMachine.change(&"grab")

func stop_grab() -> void:
	grabbed_block = null

func pickup(c: Carryable2D) -> void:
	carried = c
	$StateMachine.change(&"carry")
