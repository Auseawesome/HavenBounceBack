class_name FloatTrait
extends Trait

# Base value before any modifiers
@export
var base_value: float = 0

# Multiplier on base value, acts before exponent
@export
var pre_mult: float = 1

# Exponent, acts after multiplier
@export
var exponent: float = 1

# Multiplier after exponent
@export
var post_mult: float = 1

# Bonus value added after all other modifiers
@export
var bonus_value: float = 0

func get_value() -> float:
	return pow(base_value * pre_mult, exponent) * post_mult + bonus_value
