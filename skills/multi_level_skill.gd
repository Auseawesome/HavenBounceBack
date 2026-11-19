class_name MultiLevelSkill
extends Skill

@export
var max_level: int = 2

var current_level: int = 0

func canUpgradeSkill() -> bool:
	return current_level < max_level

func getShopMessage() -> String:
	return resource_name + " Level: " + str(current_level) + "/" + str(max_level)
