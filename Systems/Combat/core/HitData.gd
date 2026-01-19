extends Resource
class_name HitData

@export var damage: int = 1
@export var knockback: float = 140.0
@export var damage_type: StringName = &"physical"
@export var dir: Vector2 = Vector2.ZERO

var source: Node = null 
