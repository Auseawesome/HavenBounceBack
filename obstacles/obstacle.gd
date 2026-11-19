class_name Obstacle
extends StaticBody2D

@export
var max_health: int = 100

@export
var points : int = 10

@export
var obscured_material: Material

@onready
var health := max_health

func on_collision(velocity: Vector2) -> int:
	health -= velocity.length() * Globals.player.traits.damage_scale_factor
	$HealthBar.visible = true
	$ShowHealthTimer.start()
	$HealthBar/Background/Fill.anchor_right = float(health) / max_health
	if health <= 0:
		queue_free()
		return points
	return 0

func _on_show_health_timer_timeout() -> void:
	$HealthBar.visible = false

func _on_player_obscured(_body: Node) -> void:
	$Sprite2D.material = obscured_material

func _on_player_not_obscured(_body: Node) -> void:
	$Sprite2D.material = null
