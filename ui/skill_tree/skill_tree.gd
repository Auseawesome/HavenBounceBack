extends Control

var world_node : Node

var speed: float = 1
var damage: float = 1
var bounce: float = 0.5

var current_points: int :
	set(value):
		current_points = value
		Globals.skill_points_label.text = "Skill Points: " + str(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.skill_tree = self
	$LevelEnterButton.pressed.connect(Globals.enter_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reopen_skill_tree() -> void:
	visible = true
	Globals.skill_points_label.position.y = 10
	world_node.queue_free()
