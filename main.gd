extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.main = self
	print(load("res://skills/trait/bounciness.tres").get_value())
