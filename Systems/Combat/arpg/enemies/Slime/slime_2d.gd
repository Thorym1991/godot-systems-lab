extends CharacterBody2D
class_name Slime2D

@export var speed: float = 40.0
@export var contact_damage: int = 1
@export var contact_cooldown: float = 0.6
@export var knockback_resist: float = 1.0 # 1.0 = normal, >1 weniger KB

@onready var health: HealthComponent2D = $Health
@onready var contact_area: Area2D = $ContactDamage

var _contact_cd_left := 0.0
var _stun_left := 0.0

func _ready() -> void:
	contact_area.body_entered.connect(_on_body_entered)
	if health:
		health.died.connect(_on_died)

func _physics_process(delta: float) -> void:
	if _contact_cd_left > 0.0:
		_contact_cd_left = maxf(_contact_cd_left - delta, 0.0)

	if _stun_left > 0.0:
		_stun_left = maxf(_stun_left - delta, 0.0)
		move_and_slide()
		return

	# Mini-AI: langsam zum Player (MVP)
	var p := get_tree().get_first_node_in_group("player") as Node2D
	if p:
		var dir := (p.global_position - global_position)
		if dir.length() > 4.0:
			velocity = dir.normalized() * speed
		else:
			velocity = Vector2.ZERO

	move_and_slide()

func apply_hit(hit: HitData) -> void:
	if health == null:
		return
	if not health.can_take_damage():
		return

	health.take_damage(hit.damage, hit.source)

	# Knockback + kurzer Stun
	_stun_left = 0.18
	var kb := hit.knockback / maxf(knockback_resist, 0.01)
	velocity = hit.dir.normalized() * kb

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
	queue_free()
