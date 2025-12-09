extends PlayerState




func id() -> StringName: return &"move"

func physics_update(delta):
	character.apply_gravity(delta)
	var x = Input.get_axis("move_left", "move_right")
	character.move_x(x)

	if !character.is_on_floor():
		machine.change(&"air")
	elif x == 0.0:
		machine.change(&"idle")
	
	print("Move")

func input(event):
	if event.is_action_pressed("jump") and character.is_on_floor():
		machine.change(&"air")
