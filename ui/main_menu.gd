extends Control

func _ready() -> void:
	$Button.pressed.connect(load_game)

func load_game() -> void:
	Globals.skill_tree.visible = true
	Globals.skill_points_label.visible = true
	queue_free()
