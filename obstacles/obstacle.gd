class_name Obstacle
extends StaticBody2D

@export
var max_health: int = 100

@export
var points : int = 10

@onready
var health := max_health

func on_collision(velocity: Vector2) -> int:
	health -= velocity.length() * Globals.player.damage_scale_factor
	$HealthBar.visible = true
	$ShowHealthTimer.start()
	$HealthBar/Background/Fill.anchor_right = float(health) / max_health
	if health <= 0:
		queue_free()
		return points
	return 0

func _on_show_health_timer_timeout() -> void:
	$HealthBar.visible = false
