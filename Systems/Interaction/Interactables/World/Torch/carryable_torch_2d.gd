extends RigidBody2D
class_name CarryableTorch2D

@export_group("Torch")
@export var start_lit: bool = false
@export var can_extinguish: bool = true

@export_group("Damage")
@export var damage_enabled: bool = true
@export var damage: int = 1
@export var tick_rate: float = 0.5 # Schaden pro X Sekunden bei Kontakt

@export_group("Ignite")
@export var touch_ignite_enabled: bool = true # durch Kontakt mit Feuer an/aus
@export var ignite_from_lit_areas: bool = true # wenn ein Bereich "is_lit==true" hat

@onready var fire: AnimatedSprite2D = $Fire
@onready var smoke: AnimatedSprite2D = $Smoke
@onready var ignite_area: Area2D = $IgniteArea
@onready var damage_area: Area2D = $DamageArea
@onready var light: PointLight2D = get_node_or_null("PointLight2D")

var is_lit: bool = false
var _cooldowns: Dictionary = {} # Node -> float

func _ready() -> void:
	is_lit = start_lit
	_update_visual()

	# Ignite: wir reagieren auf Areas (Feuerquellen / Standfackeln / etc.)
	if ignite_area:
		ignite_area.area_entered.connect(_on_ignite_area_entered)

	# Damage: wir reagieren auf Bodies (Player/Gegner)
	if damage_area:
		damage_area.body_entered.connect(_on_damage_body_entered)
		damage_area.body_exited.connect(_on_damage_body_exited)

func _process(delta: float) -> void:
	# Cooldowns runterzählen
	if _cooldowns.size() > 0:
		var to_remove: Array = []
		for b in _cooldowns.keys():
			if not is_instance_valid(b):
				to_remove.append(b)
				continue
			_cooldowns[b] = maxf(_cooldowns[b] - delta, 0.0)
		for b in to_remove:
			_cooldowns.erase(b)

	# Overlap-Damage ticken
	if is_lit and damage_enabled and damage_area and damage_area.monitoring:
		for body in damage_area.get_overlapping_bodies():
			_try_damage(body)

# -------------------------
# Public API (für später)
# -------------------------

func ignite(_source: Node = null) -> void:
	if is_lit:
		return
	is_lit = true
	_update_visual()

func extinguish(_source: Node = null) -> void:
	if not can_extinguish:
		return
	if not is_lit:
		return
	is_lit = false
	_update_visual()

# -------------------------
# Visuals / Areas
# -------------------------

func _update_visual() -> void:
	if is_lit:
		if fire:
			fire.visible = true
			fire.play("burn")
		if smoke:
			smoke.visible = true
			smoke.play("smoke")
		if light:
			light.enabled = true

		# Damage nur wenn brennt
		if damage_area:
			damage_area.monitoring = damage_enabled
	else:
		if fire:
			fire.stop()
			fire.visible = false
		if smoke:
			smoke.stop()
			smoke.visible = false
		if light:
			light.enabled = false

		# Damage aus wenn aus
		if damage_area:
			damage_area.monitoring = false

		_cooldowns.clear()

# -------------------------
# Ignite Handling
# -------------------------

func _on_ignite_area_entered(a: Area2D) -> void:
	if not touch_ignite_enabled:
		return
	if a == null:
		return

	# 1) Wenn wir brennen und das andere kann ignite -> wir zünden es an
	if is_lit and a.has_method("ignite"):
		a.ignite(self)
		return

	# 2) Wenn wir aus sind und das andere "is_lit" hat -> wir gehen an
	if (not is_lit) and ignite_from_lit_areas and ("is_lit" in a) and a.is_lit:
		ignite(a)
		return

	# 3) Wenn wir aus sind und das andere eine explizite Feuerquelle ist:
	#    (optional: wenn du FireHazard später "provides_fire" gibst)
	if (not is_lit) and ("provides_fire" in a) and a.provides_fire:
		ignite(a)

# -------------------------
# Damage Handling
# -------------------------

func _on_damage_body_entered(body: Node) -> void:
	_try_damage(body)

func _on_damage_body_exited(body: Node) -> void:
	if _cooldowns.has(body):
		_cooldowns.erase(body)

func _try_damage(body: Node) -> void:
	if not is_lit or not damage_enabled:
		return
	if body == null:
		return

	# Cooldown pro Body
	if _cooldowns.get(body, 0.0) > 0.0:
		return

	# HealthComponent finden (Player hat "health", Gegner evtl. auch)
	var hc: HealthComponent2D = null
	if "health" in body:
		hc = body.health as HealthComponent2D
	else:
		var n := body.get_node_or_null("Health")
		hc = n as HealthComponent2D

	if hc == null:
		return
	if not hc.can_take_damage():
		return

	hc.take_damage(damage, self)
	_cooldowns[body] = tick_rate
