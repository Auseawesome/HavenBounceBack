extends Control

var world := preload("res://world.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LevelEnterButton.pressed.connect(enter_level)

func enter_level() -> void:
	get_parent().add_child(world.instantiate())
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
