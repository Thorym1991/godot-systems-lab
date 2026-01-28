extends CharacterBody2D
class_name PaintingArm2D

@export var max_hp: int = 5
@export var contact_damage: int = 1

@onready var anim: AnimatedSprite2D = $PaintingAnim
@onready var arm_root: Node2D = $armRoot
@onready var attack_area: Area2D = $armRoot/AttackArea
@onready var hurtbox: Area2D = $Hurtbox
@onready var sm: EnemyStateMachine = $EnemyStateMachine

var hp: int
var is_dead: bool = false


func _ready() -> void:
	hp = max_hp

	velocity = Vector2.ZERO

	arm_root.visible = false
	attack_area.monitoring = false

	attack_area.body_entered.connect(_on_attack_body_entered)

	add_to_group("boss_painting")

	if anim:
		anim.play("idle")

	sm.setup(self)
	sm.change(&"idle")


# ================= DAMAGE =================

func apply_hit(hit: HitData) -> void:
	if is_dead:
		return

	hp -= hit.damage

	if hp <= 0:
		is_dead = true
		sm.change(&"dead")
		return

	_flash_hit()


func _flash_hit() -> void:
	if anim and not is_dead:
		anim.play("warn")
		await get_tree().create_timer(0.08).timeout
		if not is_dead:
			anim.play("idle")


func _on_attack_body_entered(body: Node) -> void:
	if not attack_area.monitoring:
		return

	if body is TopdownPlayer2D:
		var p := body as TopdownPlayer2D
		if p.health and p.health.can_take_damage():
			p.health.take_damage(contact_damage, self)


# ================= ARM CONTROL =================

func set_attack_active(v: bool) -> void:
	arm_root.visible = v
	attack_area.monitoring = v


func play_idle() -> void:
	if anim and not is_dead:
		anim.play("idle")

func play_warn() -> void:
	if anim and not is_dead:
		anim.play("warn")

func play_dead() -> void:
	if anim:
		anim.play("dead")
