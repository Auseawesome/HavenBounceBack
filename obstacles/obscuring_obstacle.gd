class_name ObscuringObstacle
extends Area2D

@export
var obscured_material: Material

func _on_player_obscured(_body: Node) -> void:
	$"../Sprite2D".material = obscured_material

func _on_player_not_obscured(_body: Node) -> void:
	$"../Sprite2D".material = null
