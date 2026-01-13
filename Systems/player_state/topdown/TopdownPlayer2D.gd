extends CharacterBody2D
class_name TopdownPlayer2D

@export var speed: float = 150.0
var money_copper: int = 0

@onready var health: HealthComponent2D = $Health
@onready var sprite: Sprite2D = $Sprite2D
@onready var damage_feedback: DamageFeedback2D = $DamageFeedback2D

var grabbed_block: GrabBlock2D = null
var input_dir: Vector2 = Vector2.ZERO
var carried: Carryable2D = null
var _input_lock_left: float = 0.0

var checkpoint_pos: Vector2
var is_dead := false
var active_checkpoint: Node = null

@export_group("Lives / Game Over")
@export var lives_enabled: bool = false
@export_range(0, 99, 1) var start_lives: int = 3
@export_range(0, 99, 1) var max_lives: int = 3
@export var refill_lives_on_checkpoint: bool = true

var lives_left: int = 0


func _ready() -> void:
	checkpoint_pos = global_position

	lives_left = clampi(start_lives, 0, max_lives)

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

	# ✅ FeedbackBus robust
	var bus := get_node_or_null("/root/feedbackBus") as feedbackBus
	if bus:
		bus.sfx_requested.emit(&"pickup", global_position, -8.0, randf_range(0.95, 1.05))

	print("PICKUP: %s x%d | HP: %d/%d | Copper: %d"
		% [item.id, amount, health.hp, health.max_hp, money_copper])


func _on_hp_changed(current: int, max_hp: int, delta: int, source: Node) -> void:
	# optional: debug print später togglebar machen
	# print("HP CHANGED:", current, "/", max_hp, "delta:", delta)

	if delta < 0:
		if damage_feedback:
			damage_feedback.request_input_lock()
			damage_feedback.play_hurt()


func _on_died(source: Variant) -> void:
	if is_dead:
		return
	is_dead = true

	# ✅ Cleanup: Grab/Carry abbrechen, damit nix hängen bleibt
	if grabbed_block != null:
		stop_grab()
	if carried != null:
		carried = null # optional später: proper drop()

	velocity = Vector2.ZERO
	_input_lock_left = 9999.0

	if damage_feedback:
		damage_feedback.play_death()

	$StateMachine.change(&"dead")
	
	# Lives optional
	if lives_enabled:
		lives_left -= 1

		if lives_left < 0:
			await get_tree().create_timer(1.0).timeout
			game_over()
			return
	
	await get_tree().create_timer(1.0).timeout
	respawn()


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

	# ✅ FeedbackBus robust
	var bus := get_node_or_null("/root/FeedbackBus") as FeedbackBus
	if bus:
		bus.impulse_requested.emit(dir, 18.0, 0.10)


func is_grabbing() -> bool:
	return grabbed_block != null and grabbed_block.grabber == self


func set_checkpoint(pos: Vector2, checkpoint: Node = null) -> void:
	# alten deaktivieren
	if active_checkpoint and active_checkpoint != checkpoint:
		if active_checkpoint.has_method("deactivate"):
			active_checkpoint.deactivate()

	checkpoint_pos = pos
	active_checkpoint = checkpoint

	# optional refill
	if lives_enabled and refill_lives_on_checkpoint:
		lives_left = max_lives



func respawn() -> void:
	is_dead = false

	# ✅ Movement/Input wieder freigeben
	_input_lock_left = 0.0
	input_dir = Vector2.ZERO
	velocity = Vector2.ZERO

	# optional: falls irgendwas hängen bleibt
	grabbed_block = null
	carried = null

	global_position = checkpoint_pos

	if health:
		health.revive_full(self)

	$StateMachine.change(&"idle")

	var im := get_node_or_null("InteractionManager2D")
	if im and im.has_method("refresh_prompt"):
		im.call("refresh_prompt")

func game_over() -> void:
	_input_lock_left = 9999.0
	velocity = Vector2.ZERO

	print("GAME OVER")

	# Optional: nach 2 Sekunden wieder starten (Placeholder)
	await get_tree().create_timer(2.0).timeout

	# Reset und zurück zum Checkpoint
	lives_left = clampi(start_lives, 0, max_lives)
	respawn()
