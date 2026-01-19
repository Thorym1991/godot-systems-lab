extends Area2D
class_name Hurtbox2D

@export var owner_path: NodePath = NodePath("..")
@onready var owner_node: Node = get_node_or_null(owner_path)

func apply_hit(hit: HitData) -> void:
	if owner_node == null:
		return

	# Standard-Contract: apply_hit(HitData)
	if owner_node.has_method("apply_hit"):
		owner_node.call("apply_hit", hit)
		return

	# Fallback: HealthComponent direkt suchen
	var health := owner_node.get_node_or_null("Health") as HealthComponent2D
	if health and health.can_take_damage():
		health.take_damage(hit.damage, hit.source)
