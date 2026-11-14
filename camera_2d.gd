extends Camera2D

@export
var player: Node2D

var world: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	world = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y = clamp(player.position.y, world.SCREEN_SIZE*3/2 - world.world_height, world.SCREEN_SIZE/2)
