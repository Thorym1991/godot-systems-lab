extends CharacterBody2D
class_name PaintingAbilityArm

@export var contact_damage: int = 1

@onready var arm_root: Node2D = $armRoot
@onready var attack_area: Area2D = $armRoot/AttackArea
@onready var sm: EnemyStateMachine = $EnemyStateMachine

var slot: PaintingSlot2D
var is_dead := false

func set_slot(s: PaintingSlot2D) -> void:
	slot = s

func _ready() -> void:
	arm_root.visible = false
	attack_area.monitoring = false
	attack_area.body_entered.connect(_on_attack_body_entered)

	sm.setup(self)
	sm.change(&"idle")

func execute() -> void:
	print("ARM EXECUTE")
	sm.change(&"attack")  # oder wie dein State heißt


func set_attack_active(v: bool) -> void:
	arm_root.visible = v
	attack_area.monitoring = v

func _on_attack_body_entered(body: Node) -> void:
	if not attack_area.monitoring:
		return
	if body is TopdownPlayer2D:
		var p := body as TopdownPlayer2D
		if p.health and p.health.can_take_damage():
			p.health.take_damage(contact_damage, self)
