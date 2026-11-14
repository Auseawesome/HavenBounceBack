extends TextureButton

var bought_times: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	var points = Globals.skill_tree.current_points
	
	if points < 10:
		return
	points -= 10
	bought_times += 1
	$Label.text = "Times Bought: " + str(bought_times)
