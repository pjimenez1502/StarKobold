extends Control

func _ready():
	OverlaysManager.CONTROLPANEL_TOGGLE.connect(toggle_overlay_visible)

func toggle_overlay_visible(value):
	match value:
		OverlaysManager.TOGGLE_EFFECT.TOGGLE:
			match visible:
				true:
					ControlFocusManager.return_to_prev_focus()
					visible = false
				false:
					ControlFocusManager.switch_control_focus(ControlFocusManager.CONTROL_FOCUS.MENU)
					visible = true
