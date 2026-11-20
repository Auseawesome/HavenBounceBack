extends Control

func _ready() -> void:
	$Button.pressed.connect(load_game)

func load_game() -> void:
	Globals.skill_tree = Globals.skill_scene.instantiate()
	Globals.add_skill_tree()
	Globals.skill_points_label.visible = true
	queue_free()
