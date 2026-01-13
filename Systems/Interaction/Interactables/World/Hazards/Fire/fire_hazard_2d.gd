extends Area2D
class_name FireHazard2D

@onready var fire: AnimatedSprite2D = $Fire
@onready var smoke: AnimatedSprite2D = $Smoke

@export var start_lit: bool = true
var is_lit: bool = true

@export var damage: int = 1
@export var tick_rate: float = 0.5 # Schaden alle X Sekunden bei Kontakt
@export var require_can_take_damage: bool = true

# später fürs "Anzünden"
@export var apply_burn: bool = false
@export var burn_duration: float = 2.0

var _cooldowns: Dictionary = {} # Node -> float Restzeit

func _ready() -> void:
	is_lit = start_lit
	_update_visual()
	monitoring = true
	monitorable = true
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	# Cooldowns runterzählen
	if _cooldowns.size() == 0:
		return

	var to_remove: Array = []
	for body in _cooldowns.keys():
		if not is_instance_valid(body):
			to_remove.append(body)
			continue
		_cooldowns[body] = maxf(_cooldowns[body] - delta, 0.0)

	for b in to_remove:
		_cooldowns.erase(b)

	# Optional: auf Overlaps ticken (falls body_entered mal verpasst wird)
	for body in get_overlapping_bodies():
		_try_damage(body)

func _on_body_entered(body: Node) -> void:
	_try_damage(body)

func _on_body_exited(body: Node) -> void:
	# Cooldown entfernen, damit beim erneuten Betreten sofort wieder Schaden geht
	if _cooldowns.has(body):
		_cooldowns.erase(body)

func _try_damage(body: Node) -> void:
	if not is_lit:
		return

	# Cooldown check
	var cd: float = _cooldowns.get(body, 0.0)
	if cd > 0.0:
		return

	# Health finden (dein Player hat health direkt, Gegner evtl. auch)
	var hc: HealthComponent2D = null
	if "health" in body:
		hc = body.health as HealthComponent2D
	else:
		# fallback: child node "Health"
		var n := body.get_node_or_null("Health")
		hc = n as HealthComponent2D

	if hc == null:
		return

	if require_can_take_damage and not hc.can_take_damage():
		return

	hc.take_damage(damage, self)
	_cooldowns[body] = tick_rate

	# später: Burn-Status
	if apply_burn and body.has_method("apply_burn"):
		body.apply_burn(burn_duration, self)

	# Feedback (optional)
	var bus := get_node_or_null("/root/feedbackBus")
	if bus and bus.has_signal("sfx_requested"):
		bus.sfx_requested.emit(&"burn", global_position, -8.0, randf_range(0.95, 1.05))

func _update_visual() -> void:
	if is_lit:
		fire.visible = true
		fire.play("burn")
		smoke.visible = true
		smoke.play("smoke")
	else:
		fire.visible = false
		fire.stop()
		# Rauch darf optional noch kurz laufen
		smoke.visible = false
		smoke.stop()

func ignite(source: Node = null) -> void:
	if is_lit:
		return
	is_lit = true
	_update_visual()

func extinguish(source: Node = null) -> void:
	if not is_lit:
		return
	is_lit = false
	_update_visual()
