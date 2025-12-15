extends CharacterBody2D
class_name TopdownPlayer2D

@export var speed: float = 150.0

var grabbed_block: GrabBlock2D = null
var input_dir: Vector2 = Vector2.ZERO
var carried: Vase2D = null

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



func pickup(v: Vase2D) -> void:
	carried = v
	$StateMachine.change(&"carry")

func drop_carried() -> void:
	if carried:
		carried.enable_physics(true)
		carried.arm_hitbox(false)
	carried = null

func throw_carried(dir: Vector2, force: float) -> void:
	if carried:
		carried.enable_physics(true)
		carried.linear_velocity = dir.normalized() * force
	carried = null
