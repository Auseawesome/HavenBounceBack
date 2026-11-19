@abstract
class_name MultiLevelSkill
extends Skill

@export
var max_level: int = 2

var current_level: int = 0

func can_upgrade_skill() -> bool:
	return current_level < max_level

func get_shop_message() -> String:
	return resource_name + " Level: " + str(current_level) + "/" + str(max_level)
