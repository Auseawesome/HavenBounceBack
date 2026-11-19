class_name IntIncreaseSkill
extends MultiLevelSkill

@export
var target_trait: IntTrait

@export
var base_increase: int = 0

@export
var mult_increase: int = 0

@export
var bonus_increase: int = 0

func apply_skill(traits: Dictionary[String, Trait]) -> void:
	var retrieved_trait: IntTrait = traits[target_trait.id]
	
	retrieved_trait.base_value += base_increase * current_level
	retrieved_trait.multiplier += mult_increase * current_level
	retrieved_trait.bonus_value += bonus_increase * current_level
