extends CharacterBody2D
class_name Slime2D

@export var speed: float = 40.0
@export var contact_damage: int = 1
@export var contact_cooldown: float = 0.6
@export var knockback_resist: float = 1.0 # 1.0 = normal, >1 weniger KB

@onready var health: HealthComponent2D = $Health
@onready var contact_area: Area2D = $ContactDamage
@onready var sm: EnemyStateMachine = $EnemyStateMachine
@onready var aggro: AggroSensor2D = $AggroSensor2D

var _contact_cd_left := 0.0
var _stun_left := 0.0
var _target: Node2D = null
var _active: bool = false
var _hurt_time_left: float = 0.0
var _hurt_recover_state: StringName = &"idle"
var is_dead: bool = false


func _ready() -> void:
	contact_area.body_entered.connect(_on_body_entered)

	if health:
		health.died.connect(_on_died)

	aggro.target_acquired.connect(_on_target_acquired)
	aggro.target_lost.connect(_on_target_lost)

	sm.setup(self)
	sm.change(&"idle")


func _physics_process(delta: float) -> void:
	if _contact_cd_left > 0.0:
		_contact_cd_left = maxf(_contact_cd_left - delta, 0.0)

	# stun/hurt countdown kannst du später in Hurt-State verlagern
	if _stun_left > 0.0:
		_stun_left = maxf(_stun_left - delta, 0.0)

	sm._physics_process(delta)

func apply_hit(hit: HitData) -> void:
	if is_dead:
		return
	# ... rest wie gehabt ...

	if health == null:
		return
	if not health.can_take_damage():
		return

	health.take_damage(hit.damage, hit.source)

	var kb := hit.knockback / maxf(knockback_resist, 0.01)
	velocity = hit.dir.normalized() * kb

	_hurt_time_left = 0.18
	_hurt_recover_state = &"chase" if (_active and _target != null) else &"idle"

	sm.change(&"hurt")

func _on_body_entered(body: Node) -> void:
	if _contact_cd_left > 0.0:
		return
	if body == null:
		return

	# Player Contract: bevorzugt HealthComponent am Player
	if body.has_method("on_explosion"):
		# ignore (nur Beispiel)
		pass

	# Wenn Player Health hat:
	if body is TopdownPlayer2D:
		var p := body as TopdownPlayer2D
		if p.health and p.health.can_take_damage():
			p.health.take_damage(contact_damage, self)
			_contact_cd_left = contact_cooldown

func _on_died(_source: Variant) -> void:
	if is_dead:
		return
	is_dead = true
	sm.change(&"dead")




func _on_target_acquired(t: Node2D) -> void:
	_target = t
	_active = true

func _on_target_lost() -> void:
	_target = null
	_active = false
	velocity = Vector2.ZERO

func on_death() -> void:
	var dropper := get_node_or_null("LootDropper2D")
	if dropper == null:
		return

	dropper.drop(global_position)
