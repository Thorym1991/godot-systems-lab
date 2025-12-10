extends Interactable2D

signal sign_read(text: String, interactor)

@export var sign_text: String = "Hello, I am a sign."

func interact(interactor):
	emit_signal("sign_read", sign_text)
	print(sign_text)
