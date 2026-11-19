class_name IntTrait
extends Trait

# Base value before any modifiers
@export
var base_value: int = 0

# Multiplier on base value, acts before bonus
@export
var multiplier: int = 1

# Bonus value added after all other modifiers
@export
var bonus_value: int = 0

func get_value() -> int:
	return base_value * multiplier + bonus_value
