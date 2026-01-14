extends Node2D
class_name TorchStand2D

signal lit_changed(is_lit: bool)

@export var start_lit: bool = false
@export var can_extinguish: bool = false

@onready var fire: AnimatedSprite2D = $Fire
@onready var smoke: AnimatedSprite2D = $Smoke
@onready var receiver_area: Area2D = $ReceiverArea
@onready var light: PointLight2D = get_node_or_null("PointLight2D")

var is_lit: bool = false

func _ready() -> void:
	is_lit = start_lit
	_update_visual()

	if receiver_area:
		receiver_area.area_entered.connect(_on_receiver_area_entered)

func ignite(_source: Node = null) -> void:
	if is_lit:
		return
	is_lit = true
	_update_visual()
	lit_changed.emit(true)

func extinguish(_source: Node = null) -> void:
	if not can_extinguish:
		return
	if not is_lit:
		return
	is_lit = false
	_update_visual()
	lit_changed.emit(false)

func _update_visual() -> void:
	if is_lit:
		if fire:
			fire.visible = true
			fire.play("burn")
		if smoke:
			smoke.visible = true
			# falls Smoke bei dir "Smoke" heißt -> anpassen
			smoke.play("smoke")
		if light:
			light.enabled = true
	else:
		if fire:
			fire.stop()
			fire.visible = false
		if smoke:
			smoke.stop()
			smoke.visible = false
		if light:
			light.enabled = false

func _on_receiver_area_entered(a: Area2D) -> void:
	# Wenn eine brennende Handfackel (oder andere Feuerquelle) uns berührt -> ignite
	if a == null:
		return
	if is_lit:
		return

	# robust: wir akzeptieren alles, was ein is_lit bool hat
	if ("is_lit" in a) and a.is_lit:
		ignite(a)
		return

	# alternativ: parent check (falls IgniteArea an der Handfackel hängt)
	var p := a.get_parent()
	if p and ("is_lit" in p) and p.is_lit and p.has_method("ignite"):
		ignite(p)
