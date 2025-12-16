extends PlayerState

@export var carry_offset: Vector2 = Vector2(0, -20)
@export var throw_force: float = 480.0
@export var arm_delay: float = 0.08
@export var throw_if_moving: bool = true
@export var throw_spawn_distance: float = 24.0

var _arming_task_running := false

func id() -> StringName:
	return &"carry"

func enter(previous: PlayerState) -> void:
	print("ENTER CARRY STATE")
	var p := character as TopdownPlayer2D
	if p.carried == null:
		machine.change(&"idle")
		return
	p.carried.on_pickup(p)

func exit(next: PlayerState) -> void:
	_arming_task_running = false

func physics_update(delta: float) -> void:
	var p := character as TopdownPlayer2D
	var v := p.carried
	if v == null:
		machine.change(&"idle")
		return

	var c := p.carried
	c.set_carried_transform(character.global_position, carry_offset)

# Player bewegen (optional langsamer)
	var dir := p.input_dir
	character.velocity = dir.normalized() * p.speed if dir != Vector2.ZERO else Vector2.ZERO
	character.move_and_slide()

	# Hold-to-carry: wenn losgelassen -> drop oder throw
	if not Input.is_action_pressed("interact"):
		# 1) Deadzone, damit "Mini-Input" nicht als Throw zählt
		var wants_throw := throw_if_moving and dir.length() > 0.6

		if wants_throw:
			# 2) Zelda-4-Richtungs-Lock (optional aber sehr nice)
			var locked := dir
			if abs(locked.x) > abs(locked.y):
				locked = Vector2(sign(locked.x), 0.0)
			else:
				locked = Vector2(0.0, sign(locked.y))

			var throw_dir := locked.normalized()

			# 3) Vase vor dem Player spawnen (NICHT carry_offset!)
			p.carried.on_throw(p, throw_dir, throw_force)
			p.carried = null
		else:
			
			p.carried.on_drop(p)
			p.carried = null


		machine.change(&"idle")
		return


func _arm_later(v: Vase2D, thrower: Node) -> void:
	if _arming_task_running:
		return
	_arming_task_running = true
	call_deferred("_arm_later_async", v, thrower)

func _arm_later_async(v: Vase2D, thrower: Node) -> void:
	await get_tree().create_timer(arm_delay).timeout
	if v and not v.broken:
		v.arm_hitbox(true, thrower)
	_arming_task_running = false
