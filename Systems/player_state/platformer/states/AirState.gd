extends PlayerState

func _ready() -> void:
	print("AIR")

func id() -> StringName: return &"air"

func enter(prev):
	if character.is_on_floor() and Input.is_action_pressed("jump"):
		character.jump()


func physics_update(delta):
	character.apply_gravity(delta)
	character.move_x(Input.get_axis("move_left", "move_right"))

	if character.is_on_floor():
		var x = Input.get_axis("move_left", "move_right")
		machine.change(&"idle" if x == 0 else &"move")
