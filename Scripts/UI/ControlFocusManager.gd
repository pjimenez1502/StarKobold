extends Node
class_name control_focus

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

func switch_control_focus(new_focus : CONTROL_FOCUS):
	prev_control_focus = current_control_focus
	
	match new_focus:
		CONTROL_FOCUS.KOBOLD:
			pass
		CONTROL_FOCUS.SHIP:
			pass
		CONTROL_FOCUS.EDIT:
			pass
		CONTROL_FOCUS.MENU:
			pass
			
	current_control_focus = new_focus
	FOCUS_CHANGED.emit(current_control_focus)
	print("CURRENT CONTROL FOCUS: ", current_control_focus)

func return_to_prev_focus():
	current_control_focus = prev_control_focus
	FOCUS_CHANGED.emit(current_control_focus)
	print("CURRENT CONTROL FOCUS: ", current_control_focus)





func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F1:
			switch_control_focus(0)
		if event.pressed and event.keycode == KEY_F2:
			switch_control_focus(1)
		if event.pressed and event.keycode == KEY_F3:
			switch_control_focus(2)
			
