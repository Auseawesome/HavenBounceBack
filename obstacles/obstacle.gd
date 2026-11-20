class_name Obstacle
extends StaticBody2D

@export
var max_health: int = 100

@export
var points : int = 10

@onready
var health := max_health

func _ready() -> void:
	if (fmod(position.x, 1) != 0 or fmod(position.y, 1) != 0):
		print(self, " does not have a centered position")

func on_collision(velocity: Vector2) -> int:
	var damage_factor: float = Globals.traits.damage_factor.get_value()
	var damage_exp: float = Globals.traits.damage_exponent.get_value()
	
	health -= pow(velocity.length() / 1024 * damage_factor, damage_exp)
	$HealthBar.visible = true
	$ShowHealthTimer.start()
	$HealthBar/Background/Fill.anchor_right = float(health) / max_health
	if health <= 0:
		queue_free()
		return points
	return 0

func _on_show_health_timer_timeout() -> void:
	$HealthBar.visible = false
