extends Control

var world := preload("res://world.tscn")

var world_node : Node

var speed: float = 1
var damage: float = 1
var bounce: float = 0.5

var current_points: int :
	set(value):
		current_points = value
		$"../SkillPoints".text = "Skill Points: " + str(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LevelEnterButton.pressed.connect(enter_level)

func enter_level() -> void:
	world_node = world.instantiate()
	get_parent().add_child(world_node)
	visible = false
	
	world_node.set_world_height(2592)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reopen_skill_tree() -> void:
	visible = true
	$"../SkillPoints".position.y = 10
	world_node.queue_free()
