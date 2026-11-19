@abstract
class_name Trait
extends Resource

@export
var id: String

@export_custom(PROPERTY_HINT_MULTILINE_TEXT, "")
var desc: String

@export_custom(PROPERTY_HINT_MULTILINE_TEXT, "")
var dev_notes: String

@abstract
func get_value() -> Variant
