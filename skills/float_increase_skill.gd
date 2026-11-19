class_name FloatIncreaseSkill
extends MultiLevelSkill

@export
var target_trait: FloatTrait

@export
var base_increase: float = 0

@export
var pre_mult_increase: float = 0

@export
var exponent_increase: float = 0

@export
var post_mult_increase: float = 0

@export
var bonus_increase: float = 0

func apply_skill(traits: Dictionary[String, Trait]) -> void:
	var retrieved_trait: FloatTrait = traits[target_trait.id]
	
	retrieved_trait.base_value += base_increase * current_level
	retrieved_trait.pre_mult += pre_mult_increase * current_level
	retrieved_trait.exponent += exponent_increase * current_level
	retrieved_trait.post_mult += post_mult_increase * current_level
	retrieved_trait.bonus_value += bonus_increase * current_level
