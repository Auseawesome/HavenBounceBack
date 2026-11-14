extends Node2D

const SCREEN_SIZE := 864

var world_height := SCREEN_SIZE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level := preload("res://levels/template_level.tscn")
	$LayerContainer.add_child(level.instantiate())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_world_height(height: int) -> void:
	world_height = height
	$BottomBoundary/CollisionShape2D.position.y = height - 256
