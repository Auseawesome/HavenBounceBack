extends Node

@export
var title_text: Theme

@export
var large_text: Theme

@export
var med_text: Theme

func _ready() -> void:
	Globals.main = self
	text_resize()
	get_window().size_changed.connect(text_resize)

const TARGET_ASPECT: float = 16.0/9.0

func get_window_scale_needed() -> float:
	var window_size := get_window().size
	
	var window_aspect := float(window_size.x) / window_size.y
	var scale_needed: float
	if window_aspect > TARGET_ASPECT:
		scale_needed = window_aspect / TARGET_ASPECT
	else:
		scale_needed = TARGET_ASPECT / window_aspect
	
	return scale_needed

func text_resize() -> void:
	var window_size := get_window().size
	
	var window_aspect := float(window_size.x) / window_size.y
	var scale_needed := get_window_scale_needed()
	
	title_text.default_font_size = 54 * scale_needed
	large_text.default_font_size = 32 * scale_needed
	med_text.default_font_size = 24 * scale_needed
