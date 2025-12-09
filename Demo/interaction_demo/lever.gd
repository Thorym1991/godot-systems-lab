extends Interactable2D

var is_on: bool = false

func interact(interactor):
	if not enabled:
		return

	is_on = !is_on
	print("Hebel umgelegt! Zustand:", is_on)
