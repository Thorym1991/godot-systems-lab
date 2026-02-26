extends Marker2D
class_name SpikeSlot2D

@export var group: StringName = &"default"   # z.B. "ring", "lane", "center"
@export var weight: float = 1.0              # optional fürs Random
@export var enabled: bool = true

func _ready() -> void:
	print(name, " groups=", get_groups())


func is_enabled() -> bool:
	return enabled
