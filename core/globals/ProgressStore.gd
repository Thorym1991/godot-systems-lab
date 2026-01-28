extends Node
class_name ProgressStore

var flags: Dictionary = {}

func set_flag(k: StringName, v: bool) -> void:
	flags[k] = v

func has_flag(k: StringName) -> bool:
	return bool(flags.get(k, false))
