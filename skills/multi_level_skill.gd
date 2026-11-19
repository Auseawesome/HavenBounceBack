@abstract
class_name MultiLevelSkill
extends Skill

@export
var max_level: int = 2

var current_level: int = 0

func can_upgrade_skill() -> bool:
	return current_level < max_level

func upgrade_skill() -> bool:
	if not can_upgrade_skill():
		return false
	
	current_level += 1
	return true

func get_shop_message() -> String:
	return str(self)

func _to_string() -> String:
	return resource_name + " Level: " + str(current_level) + "/" + str(max_level)
