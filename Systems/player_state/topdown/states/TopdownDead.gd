extends PlayerState
class_name PlayerStateDead

func enter(previous: PlayerState) -> void:
	# Bewegung hart stoppen
	if character:
		character.velocity = Vector2.ZERO

	# Optional: Flag setzen (wenn du es im Player hast)
	if character and ("is_dead" in character):
		character.is_dead = true

func physics_update(_delta: float) -> void:
	# bleibt stehen, kein move
	if character:
		character.velocity = Vector2.ZERO
		# Je nach deinem Player-Setup:
		# character.move_and_slide() NICHT mehr aufrufen (sollte im Player passieren)
		# Hier nur "still halten".

func input(_event: InputEvent) -> void:
	# keine Inputs im Dead state
	pass

func exit(next: PlayerState) -> void:
	if character and ("is_dead" in character):
		character.is_dead = false

func id() -> StringName:
	return &"dead"
