extends Control
class_name FeedbackPopup

@onready var slider_fun: HSlider = %SliderFun
@onready var label_fun: Label = %LabelFun

@onready var slider_clarity: HSlider = %SliderClarity
@onready var label_clarity: Label = %LabelClarity

@onready var difficulty: OptionButton = %Difficulty
@onready var cb_spikes: CheckBox = %CBSpikes
@onready var cb_arm: CheckBox = %CBArm
@onready var cb_sog: CheckBox = %CBSog
@onready var cb_tennis: CheckBox = %CBTennis

@onready var comment: TextEdit = %Comment
@onready var status_label: Label = %Status

func _ready() -> void:
	# Defaults
	slider_fun.min_value = 1
	slider_fun.max_value = 5
	slider_fun.step = 1
	slider_fun.value = 4

	slider_clarity.min_value = 1
	slider_clarity.max_value = 5
	slider_clarity.step = 1
	slider_clarity.value = 3

	difficulty.clear()
	difficulty.add_item("zu leicht", 0)
	difficulty.add_item("ok", 1)
	difficulty.add_item("zu schwer", 2)
	difficulty.select(1)

	_update_labels()

	slider_fun.value_changed.connect(func(_v): _update_labels())
	slider_clarity.value_changed.connect(func(_v): _update_labels())

func _update_labels() -> void:
	label_fun.text = "Spaß: %d/5" % int(slider_fun.value)
	label_clarity.text = "Verständlichkeit: %d/5" % int(slider_clarity.value)

func _on_send_pressed() -> void:
	var payload := _collect_payload()
	var path := feedbackManager.submit_feedback(payload)
	if path == "":
		status_label.text = "Konnte nicht speichern."
		return
	status_label.text = "Gespeichert: %s" % path

func _on_copy_pressed() -> void:
	var payload := _collect_payload()
	var txt := feedbackManager.build_share_text(payload)
	DisplayServer.clipboard_set(txt)
	status_label.text = "In Zwischenablage kopiert."

func _on_cancel_pressed() -> void:
	queue_free()

func _collect_payload() -> Dictionary:
	var liked: Array[String] = []
	if cb_spikes.button_pressed: liked.append("spikes")
	if cb_arm.button_pressed: liked.append("arm")
	if cb_sog.button_pressed: liked.append("sog")
	if cb_tennis.button_pressed: liked.append("tennis")

	return {
		"fun": int(slider_fun.value),
		"clarity": int(slider_clarity.value),
		"difficulty": difficulty.get_item_text(difficulty.selected),
		"liked": liked,
		"comment": comment.text.strip_edges()
	}
