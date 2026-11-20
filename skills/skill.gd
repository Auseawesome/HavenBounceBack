@abstract
class_name Skill
extends Resource

@export
var icon: Texture2D

@export_custom(PROPERTY_HINT_MULTILINE_TEXT, "")
var desc: String

@export
var cost: CostProvider

@abstract
func can_upgrade_skill() -> bool

@abstract
func upgrade_skill() -> bool

@abstract
func apply_skill(traits: Dictionary[String, Trait]) -> void

@abstract
func get_shop_message() -> String

@abstract
func bought_at_least_once() -> bool

@abstract
func get_proportion_completed() -> float
