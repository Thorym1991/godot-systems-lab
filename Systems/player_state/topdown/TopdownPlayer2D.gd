extends CharacterBody2D
class_name TopdownPlayer2D

@export var speed: float = 150.0
var money_copper: int = 0

@export_group("Combat")
@export var sword_hitbox_path: NodePath = NodePath("SwordPivot/SwordHitbox")
@export var sword_pivot_path: NodePath = NodePath("SwordPivot")
@export var sword_offset: float = 14.0
@export_group("Ranged")
@export var arrow_scene: PackedScene
@export var arrow_damage: int = 1
@export var arrow_speed: float = 260.0
@export var perfect_block_window: float = 0.12



@onready var sword_hitbox: Hitbox2D = get_node_or_null(sword_hitbox_path) as Hitbox2D
@onready var sword_pivot: Node2D = get_node_or_null(sword_pivot_path) as Node2D
@onready var sword_parry_hitbox: Area2D = $SwordPivot/SwordParryHitbox
@onready var shield_block_hitbox: Area2D = $ShieldBlockHitbox


@onready var health: HealthComponent2D = $Health
@onready var damage_feedback: DamageFeedback2D = $DamageFeedback2D

var grabbed_block: GrabBlock2D = null
var carried: Carryable2D = null
var input_dir: Vector2 = Vector2.ZERO
var _input_lock_left: float = 0.0

var facing_dir: Vector2 = Vector2.DOWN

var checkpoint_pos: Vector2
var is_dead := false
var active_checkpoint: Node = null
var perfect_block_active := false

@export_group("Lives / Game Over")
@export var lives_enabled: bool = false
@export_range(0, 99, 1) var start_lives: int = 3
@export_range(0, 99, 1) var max_lives: int = 3
@export var refill_lives_on_checkpoint: bool = true
var lives_left: int = 0

func _ready() -> void:
	add_to_group("player")
	checkpoint_pos = global_position
	lives_left = clampi(start_lives, 0, max_lives)

	if sword_hitbox:
		sword_hitbox.area_entered.connect(_on_sword_area_entered)
	else:
		push_error("Player: SwordHitbox not found at %s" % str(sword_hitbox_path))

	if health:
		health.hp_changed.connect(_on_hp_changed)
		health.died.connect(_on_died)

	_update_sword_pivot()

func _physics_process(delta: float) -> void:
	# Input-Lock (Hitstop/Death etc.)
	if _input_lock_left > 0.0:
		_input_lock_left = maxf(_input_lock_left - delta, 0.0)
		input_dir = Vector2.ZERO
		_update_sword_pivot()
		return

	input_dir = Input.get_vector("move_left","move_right","move_up","move_down")
	_set_facing_from_input(input_dir)
	_update_sword_pivot()
	if Input.is_action_just_pressed("shoot"):
		shoot_arrow()


func _set_facing_from_input(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		return

	# Zelda-like 4-dir snap
	if absf(dir.x) > absf(dir.y):
		facing_dir = Vector2.RIGHT if dir.x > 0.0 else Vector2.LEFT
	else:
		facing_dir = Vector2.DOWN if dir.y > 0.0 else Vector2.UP

func _update_sword_pivot() -> void:
	if sword_pivot == null:
		return
	sword_pivot.position = facing_dir * sword_offset

# ---- Carry/Grab (wie gehabt) ----

func pickup(c: Carryable2D) -> void:
	carried = c
	$StateMachine.change(&"carry")

func start_grab(block: GrabBlock2D) -> void:
	if is_dead: return
	if carried != null: return
	grabbed_block = block
	$StateMachine.change(&"grab")

func stop_grab() -> void:
	grabbed_block = null

func is_grabbing() -> bool:
	return grabbed_block != null and grabbed_block.grabber == self

# ---- Items / HUD ----

func pickup_item(item: ItemData, amount: int) -> void:
	if item.heal_amount > 0 and health:
		health.heal(item.heal_amount * amount, self)

	if item.value_copper > 0:
		money_copper += item.value_copper * amount

	var bus := get_node_or_null("/root/feedbackBus") as feedbackBus
	if bus:
		bus.sfx_requested.emit(&"pickup", global_position, -8.0, randf_range(0.95, 1.05))

	_refresh_hud()

func _refresh_hud() -> void:
	var hud := get_tree().get_first_node_in_group("hud_player_stats")
	if hud and hud.has_method("refresh_all"):
		hud.call("refresh_all")

# ---- Damage / Death (wie gehabt) ----

func _on_hp_changed(_current: int, _max_hp: int, delta: int, _source: Node) -> void:
	if delta < 0 and damage_feedback:
		damage_feedback.request_input_lock()
		damage_feedback.play_hurt()

func _on_died(_source: Variant) -> void:
	if is_dead: return
	is_dead = true

	if grabbed_block != null:
		stop_grab()
	if carried != null:
		carried = null

	velocity = Vector2.ZERO
	_input_lock_left = 9999.0

	if damage_feedback:
		damage_feedback.play_death()

	$StateMachine.change(&"dead")

	if lives_enabled:
		lives_left -= 1
		if lives_left < 0:
			await get_tree().create_timer(1.0).timeout
			game_over()
			return

	await get_tree().create_timer(1.0).timeout
	respawn()
	_refresh_hud()

func set_checkpoint(pos: Vector2, checkpoint: Node = null) -> void:
	if active_checkpoint and active_checkpoint != checkpoint:
		if active_checkpoint.has_method("deactivate"):
			active_checkpoint.deactivate()

	checkpoint_pos = pos
	active_checkpoint = checkpoint

	if lives_enabled and refill_lives_on_checkpoint:
		lives_left = max_lives

func respawn() -> void:
	is_dead = false
	_input_lock_left = 0.0
	input_dir = Vector2.ZERO
	velocity = Vector2.ZERO
	grabbed_block = null
	carried = null

	global_position = checkpoint_pos

	if health:
		health.revive_full(self)

	$StateMachine.change(&"idle")

	var im := get_node_or_null("InteractionManager2D")
	if im and im.has_method("refresh_prompt"):
		im.call("refresh_prompt")

	_refresh_hud()

func game_over() -> void:
	_input_lock_left = 9999.0
	velocity = Vector2.ZERO
	print("GAME OVER")

	await get_tree().create_timer(2.0).timeout
	lives_left = clampi(start_lives, 0, max_lives)
	respawn()

# ---- Combat API (für Attack-State) ----

func sword_swing_start() -> void:
	if sword_hitbox:
		sword_hitbox.start_swing(self)

func sword_swing_end() -> void:
	if sword_hitbox:
		sword_hitbox.end_swing()

func _on_sword_area_entered(a: Area2D) -> void:
	# Robust: nicht auf "is Hurtbox2D" bestehen, nur apply_hit erwarten
	if not a.has_method("apply_hit"):
		return

	var owner := a.get_parent()
	var dir := facing_dir
	if owner is Node2D:
		dir = ((owner as Node2D).global_position - global_position).normalized()

	if sword_hitbox and sword_hitbox.can_hit(owner):
		sword_hitbox.mark_hit(owner)
		a.call("apply_hit", sword_hitbox.make_hit(dir))

func shoot_arrow() -> void:
	if arrow_scene == null:
		push_warning("Player: arrow_scene not set")
		return

	var a := arrow_scene.instantiate() as Projectile2D
	if a == null:
		push_warning("Player: arrow_scene is not Projectile2D")
		return

	# Spawn vor dem Player (ähnlich wie SwordPivot)
	a.global_position = global_position + facing_dir * 10.0
	a.speed = arrow_speed
	a.setup(facing_dir, arrow_damage, self, 80.0)

	get_tree().current_scene.add_child(a)
