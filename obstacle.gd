class_name Obstacle
extends StaticBody2D

@export
var max_health: int = 100

@onready
var health := max_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_collision(velocity: Vector2) -> void:
	health -= velocity.length() / 10
	$HealthBar/Background/Fill.anchor_right = float(health) / max_health
	if health <= 0:
		queue_free()
