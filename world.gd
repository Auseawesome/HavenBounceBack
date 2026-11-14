extends Node2D

const SCREEN_SIZE := 864

var world_height := SCREEN_SIZE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_world_height(height: int) -> void:
	world_height = height
	$TopBoundary/CollisionShape2D.position.y = SCREEN_SIZE - height
