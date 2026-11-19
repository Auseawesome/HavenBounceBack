class_name Skill
extends Resource

@export_custom(PROPERTY_HINT_MULTILINE_TEXT, "")
var desc: String

func canUpgradeSkill() -> bool:
	return false

func applySkill(traits: Dictionary[String, Trait]) -> void:
	pass

func getShopMessage() -> String:
	return "Unimplemented"
