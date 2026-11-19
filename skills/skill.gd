class_name Skill
extends Resource

func canUpgradeSkill() -> bool:
	return false

func applySkill(traits: Dictionary[String, Trait]) -> void:
	pass

func getShopMessage() -> String:
	return "Unimplemented"
