extends Area2D

@onready var player := owner

func _ready():
	area_entered.connect(_on_area)

func _on_area(a: Area2D) -> void:
	if a is Projectile2D:
		var p := a as Projectile2D

		if player.perfect_block_active:
			p.reflect(player, player.facing_dir)
		else:
			p.queue_free()
