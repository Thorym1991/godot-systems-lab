extends Node
class_name FeedbackBus

signal sfx_requested(name: StringName, pos: Vector2, volume_db: float, pitch: float)
signal shake_requested(intensity: float, duration: float)
signal impulse_requested(dir: Vector2, strength: float, duration: float)
