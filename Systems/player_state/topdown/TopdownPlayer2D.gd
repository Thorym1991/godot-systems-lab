extends CharacterBody2D
class_name TopdownPlayer2D

@export var speed: float = 150.0
@export var max_hp: int = 6
var hp: int = 6
var money_copper: int = 0


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

func pickup_item(item: ItemData, amount: int) -> void:
	# Heal
	if item.heal_amount > 0:
		hp = mini(hp + item.heal_amount * amount, max_hp)

	# Money
	if item.value_copper > 0:
		money_copper += item.value_copper * amount

	# (optional) Feedback
	feedbackBus.sfx_requested.emit(&"pickup", global_position, -8.0, randf_range(0.95, 1.05))
	print(
	"PICKUP: %s x%d | HP: %d | Copper: %d"
	% [item.id, amount, hp, money_copper]
)
