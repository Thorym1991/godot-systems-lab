extends Area2D
class_name  InteractionManager2D

@export var player: Node2D
@export var interact_action: StringName =&"ui_accept"

var _nearby: Array[Interactable2D] = []
var _current_target: Interactable2D = null

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(interact_action):
		if _current_target !=null:
			_current_target.interact(player)
			globalsignals.player_interacted.emit(_current_target)

func _on_area_entered(area: Area2D) -> void:
	if area is Interactable2D and not _nearby.has(area):
		_nearby.append(area)
		_update_current_target()

func _on_area_exited(area: Area2D) -> void:
	if area is Interactable2D:
		_nearby.erase(area)
		_update_current_target()

func _update_current_target() -> void:
	if _nearby.is_empty():
		_current_target = null
	else:
		_nearby.sort_custom(Callable(self, "_sort_by_interaction_priority"))
		_current_target = _nearby[0]
		
	globalsignals.interaction_target_changed.emit(_current_target)

func _sort_by_interaction_pritoity(a: Interactable2D, b: Interactable2D) -> bool:
	return a.interaction_priority > b.interaction_priority
	
func get_current_target() -> Interactable2D:
	return _current_target
