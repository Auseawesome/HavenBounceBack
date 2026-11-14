extends Control

var skill_tree := preload("res://skill_tree.tscn")

func _ready() -> void:
	$Button.pressed.connect(load_game)

func load_game() -> void:
	get_parent().add_child(skill_tree.instantiate())
	Globals.skill_points_label.visible = true
	queue_free()
