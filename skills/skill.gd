@abstract
class_name Skill
extends Resource

@export_custom(PROPERTY_HINT_MULTILINE_TEXT, "")
var desc: String

@export
var cost: CostProvider

@abstract
func canUpgradeSkill() -> bool

@abstract
func applySkill(traits: Dictionary[String, Trait]) -> void

@abstract
func getShopMessage() -> String
