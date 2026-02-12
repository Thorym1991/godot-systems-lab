extends EnemyState
class_name PaintingStateAttack

@export var extend_time: float = 0.12
@export var active_time: float = 0.18
@export var retract_time: float = 0.10

func id() -> StringName:
	return &"attack"

func enter() -> void:
	var e: PaintingAbilityArm = enemy as PaintingAbilityArm
	if e == null:
		machine.change(&"idle")
		return

	var arm_root := e.arm_root
	if arm_root == null:
		push_warning("PaintingStateAttack: ArmRoot missing")
		machine.change(&"idle")
		return

	arm_root.visible = true

	var start_rot: float = deg_to_rad(0.0)
	var end_rot: float = deg_to_rad(-120.0)
	arm_root.rotation = start_rot

	e.set_attack_active(true)

	var tw := get_tree().create_tween()
	tw.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tw.tween_property(arm_root, "rotation", end_rot, extend_time)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	await tw.finished

	await get_tree().create_timer(active_time).timeout

	e.set_attack_active(false)

	var tw2 := get_tree().create_tween()
	tw2.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tw2.tween_property(arm_root, "rotation", start_rot, retract_time)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
	await tw2.finished

	arm_root.visible = false

	if not e.is_dead:
		machine.change(&"idle")
