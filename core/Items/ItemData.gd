extends Resource
class_name ItemData

@export var id: StringName = &""
@export var display_name: String = ""
@export var icon: Texture2D

# Effects (Phase 1)
@export var heal_amount: int = 0      # HP per item
@export var value_copper: int = 0     # Kupfer per item

# Future-proof
@export var mana_amount: int = 0
@export var stackable: bool = true
@export var max_stack: int = 99
