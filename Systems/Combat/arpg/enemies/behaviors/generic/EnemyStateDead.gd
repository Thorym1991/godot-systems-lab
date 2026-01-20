extends EnemyState
class_name EnemyStateDead

func id() -> StringName:
	return &"dead"

func enter() -> void:
	print("[State] Dead enter")

	enemy.velocity = Vector2.ZERO

	# Mark dead on host (so apply_hit kann sofort blocken)
	enemy.set("is_dead", true)

	# --- Physics-safe: deferred changes ---
	var hurtbox := enemy.get_node_or_null("Hurtbox") as Area2D
	if hurtbox:
		hurtbox.set_deferred("monitoring", false)
		hurtbox.set_deferred("monitorable", false)

	var contact := enemy.get_node_or_null("ContactDamage") as Area2D
	if contact:
		contact.set_deferred("monitoring", false)
		contact.set_deferred("monitorable", false)

	var body_col := enemy.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if body_col:
		body_col.set_deferred("disabled", true)
	# Enemy-spezifischer Hook (Loot/FX)
	if enemy.has_method("on_death"):
		enemy.call("on_death")

	# queue_free ist meistens okay, aber wir machen es auch deferred-sauber
	enemy.call_deferred("queue_free")
