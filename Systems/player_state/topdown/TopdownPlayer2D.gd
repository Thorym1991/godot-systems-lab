extends CharacterBody2D
class_name TopdownPlayer2D

@export var speed: float = 150.0
var money_copper: int = 0

@onready var health: HealthComponent2D = $Health
@onready var sprite: Sprite2D = $Sprite2D

var grabbed_block: GrabBlock2D = null
var input_dir: Vector2 = Vector2.ZERO
var carried: Carryable2D = null
var _input_lock_left: float = 0.0

func _ready() -> void:
	# optional: falls du Feedback/Debug willst
	if health:
		health.hp_changed.connect(_on_hp_changed)
		health.died.connect(_on_died)

func _physics_process(delta: float) -> void:
	if _input_lock_left > 0.0:
		_input_lock_left = maxf(_input_lock_left - delta, 0.0)
		input_dir = Vector2.ZERO
		return

	input_dir = Input.get_vector("move_left","move_right","move_up","move_down")

func pickup(c: Carryable2D) -> void:
	carried = c
	$StateMachine.change(&"carry")

# ✅ Grab API (für Interactables wie GrabBlock)
func start_grab(block: GrabBlock2D) -> void:
	if is_dead:
		return
	if carried != null:
		return
	grabbed_block = block
	$StateMachine.change(&"grab")

func stop_grab() -> void:
	grabbed_block = null

func pickup_item(item: ItemData, amount: int) -> void:
	# Heal über HealthComponent
	if item.heal_amount > 0 and health:
		health.heal(item.heal_amount * amount, self)

	# Money bleibt im Player (oder später WalletComponent)
	if item.value_copper > 0:
		money_copper += item.value_copper * amount

	feedbackBus.sfx_requested.emit(&"pickup", global_position, -8.0, randf_range(0.95, 1.05))

	print("PICKUP: %s x%d | HP: %d/%d | Copper: %d"
		% [item.id, amount, health.hp, health.max_hp, money_copper])

func _on_hp_changed(current: int, max_hp: int, delta: int, source: Node) -> void:
	print("HP CHANGED:", current, "/", max_hp, "delta:", delta, " sprite=", sprite)

	if delta < 0:
		_input_lock_left = maxf(_input_lock_left, 0.10)
		feedbackBus.sfx_requested.emit(&"hurt", global_position, -6.0, randf_range(0.95, 1.05))
		_hurt_flash()

var is_dead := false

func _on_died(source: Variant) -> void:
	if is_dead:
		return
	is_dead = true

	velocity = Vector2.ZERO
	_input_lock_left = 9999.0

	var bus := get_node_or_null("/root/FeedbackBus") as FeedbackBus
	if bus:
		bus.shake_requested.emit(0.8, 0.25)

	$StateMachine.change(&"dead")
	print("PLAYER DIED. source=", source)

func on_explosion(pos: Vector2, _force: float) -> void:
	if health == null:
		return
	if not health.can_take_damage():
		return

	health.take_damage(1, self)

	var dir := (global_position - pos)
	if dir.length() < 0.001:
		dir = Vector2.UP
	dir = dir.normalized()

	feedbackBus.impulse_requested.emit(dir, 18.0, 0.10)

func is_grabbing() -> bool:
	return grabbed_block != null and grabbed_block.grabber == self

var _flashing := false

func _hurt_flash() -> void:
	if sprite == null or _flashing:
		return
	_flashing = true

	for i in range(3):
		sprite.modulate.a = 0.2
		await get_tree().create_timer(0.04).timeout
		if not is_instance_valid(sprite): break
		sprite.modulate.a = 1.0
		await get_tree().create_timer(0.04).timeout
		if not is_instance_valid(sprite): break

	_flashing = false
