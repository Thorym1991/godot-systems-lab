extends Interactable2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var block_collider: CollisionShape2D = $Blockbody/BlockCollider

var is_open: bool = false

func interact(interactor: Node) -> void:
	if is_open:
		close_door()
	else:
		open_door()


func open_door() -> void:
	is_open = true

	# 1. Tür durchsichtig machen
	sprite.modulate.a = 0.0  # Alpha-Kanal = komplett transparent

	# 2. BlockCollider deaktivieren → Spieler kann durchlaufen
	block_collider.disabled = true

func close_door() -> void:
	is_open = false

	# 1. Tür durchsichtig machen
	sprite.modulate.a = 1.0  # Alpha-Kanal = komplett transparent

	# 2. BlockCollider deaktivieren → Spieler kann durchlaufen
	block_collider.disabled = false
