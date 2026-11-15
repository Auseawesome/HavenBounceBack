extends Node

var main: Node

var player: RigidBody2D

var skill_tree: Control
var skill_points_label: Label

var world_scene := preload("res://world/world.tscn")
var world: Node2D

func enter_level() -> void:
	world = world_scene.instantiate()
	main.add_child(world)
	skill_tree.visible = false
	
	world.set_world_height(2592)

func exit_level() -> void:
	world.queue_free()
	skill_tree.visible = true
	Globals.skill_points_label.position.y = 10
