extends Area2D
class_name LootPickup2D

@export var item: ItemData
@export var amount: int = 1

@onready var sprite: Sprite2D = get_node_or_null("Sprite2D") as Sprite2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_refresh_visual()

func _refresh_visual() -> void:
	if sprite == null:
		return
	if item != null and item.icon != null:
		sprite.texture = item.icon

func _on_body_entered(body: Node) -> void:
	if item == null:
		return

	# Player should implement pickup_item(item, amount)
	if body.has_method("pickup_item"):
		body.call("pickup_item", item, amount)
		queue_free()
