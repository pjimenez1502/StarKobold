extends Control

func _ready():
	OverlaysManager.EDIT_TOGGLE.connect(toggle_overlay_visible)
	
func toggle_overlay_visible(value):
	visible = value
