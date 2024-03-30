extends Node

signal FOCUS_CHANGED

enum CONTROL_FOCUS {
	KOBOLD, ## Right Click controls pathfinding.    # wasd for keys?
	SHIP, ## WASDQE for ship control. No mouse.     # mouse for targeting?
	EDIT, ## Mouse to place. R to rotate
	MENU, ## Mouse to interact with menus
}

var current_control_focus : CONTROL_FOCUS
var prev_control_focus : CONTROL_FOCUS

func _ready():
	current_control_focus = CONTROL_FOCUS.KOBOLD

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("ControlFocusKobold"):
			switch_control_focus(0)
		if Input.is_action_just_pressed("ControlFocusShip"):
			switch_control_focus(1)
		if Input.is_action_just_pressed("ControlFocusEdit"):
			switch_control_focus(2)
			
func switch_control_focus(new_focus : CONTROL_FOCUS):
	prev_control_focus = current_control_focus
	
	match new_focus:
		CONTROL_FOCUS.KOBOLD:
			OverlaysManager.toggle_kobold_overlay(true)
			OverlaysManager.toggle_ship_overlay(false)
			OverlaysManager.toggle_edit_overlay(false)
			pass
		CONTROL_FOCUS.SHIP:
			OverlaysManager.toggle_kobold_overlay(false)
			OverlaysManager.toggle_ship_overlay(true)
			OverlaysManager.toggle_edit_overlay(false)
			pass
		CONTROL_FOCUS.EDIT:
			OverlaysManager.toggle_kobold_overlay(false)
			OverlaysManager.toggle_ship_overlay(false)
			OverlaysManager.toggle_edit_overlay(true)
			pass
		CONTROL_FOCUS.MENU:
			OverlaysManager.toggle_kobold_overlay(false)
			OverlaysManager.toggle_ship_overlay(false)
			OverlaysManager.toggle_edit_overlay(false)
			pass

	current_control_focus = new_focus
	FOCUS_CHANGED.emit(current_control_focus)
	print("CURRENT CONTROL FOCUS: ", current_control_focus)

func return_to_prev_focus():
	switch_control_focus(prev_control_focus)
