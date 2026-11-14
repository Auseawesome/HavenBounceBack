class_name Obstacle
extends StaticBody2D

@export
var max_health: int = 100

@onready
var health := max_health

func on_collision(velocity: Vector2) -> void:
	health -= velocity.length() / 10
	$HealthBar/Background/Fill.anchor_right = float(health) / max_health
	if health <= 0:
		queue_free()
