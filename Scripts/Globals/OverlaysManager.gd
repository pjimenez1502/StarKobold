extends Node

## CONTROL OVERLAY VIEWS
enum TOGGLE_EFFECT { OPEN, CLOSE, TOGGLE}
signal INVENTORY_TOGGLE
signal CONTROLPANEL_TOGGLE

signal KOBOLD_TOGGLE
signal SHIP_TOGGLE
signal EDIT_TOGGLE

func _input(event):
	if Input.is_action_just_pressed("HoldInventory"):
		INVENTORY_TOGGLE.emit(TOGGLE_EFFECT.OPEN)
	if Input.is_action_just_released("HoldInventory"):
		INVENTORY_TOGGLE.emit(TOGGLE_EFFECT.CLOSE)
	if Input.is_action_just_pressed("ToggleInventory"):
		INVENTORY_TOGGLE.emit(TOGGLE_EFFECT.TOGGLE)
	
	if Input.is_action_just_pressed("ToggleControlPanel"):
		CONTROLPANEL_TOGGLE.emit(TOGGLE_EFFECT.TOGGLE)



func toggle_kobold_overlay(value):
	KOBOLD_TOGGLE.emit(value)

func toggle_ship_overlay(value):
	SHIP_TOGGLE.emit(value)

func toggle_edit_overlay(value):
	EDIT_TOGGLE.emit(value)


#CONTROL MENUS DATA
signal ADD_CONTROLPANEL_GENERATOR_ENTRY
signal ADD_CONTROLPANEL_POWERED_ENTRY
signal ADD_CONTROLPANEL_HARDPOINT_ENTRY

signal REMOVE_CONTROLPANEL_GENERATOR_ENTRY
signal REMOVE_CONTROLPANEL_POWERED_ENTRY
signal REMOVE_CONTROLPANEL_HARDPOINT_ENTRY

func add_controlpanel_generator_entry(module_data):
	ADD_CONTROLPANEL_GENERATOR_ENTRY.emit(module_data)
	
func add_controlpanel_powered_entry(module_data):
	ADD_CONTROLPANEL_POWERED_ENTRY.emit(module_data)

func add_controlpanel_hardpoint_entry(module_data):
	ADD_CONTROLPANEL_HARDPOINT_ENTRY.emit(module_data)



func remove_controlpanel_generator_entry(module_data):
	REMOVE_CONTROLPANEL_GENERATOR_ENTRY.emit(module_data)
	
func remove_controlpanel_powered_entry(module_data):
	REMOVE_CONTROLPANEL_POWERED_ENTRY.emit(module_data)

func remove_controlpanel_hardpoint_entry(module_data):
	REMOVE_CONTROLPANEL_HARDPOINT_ENTRY.emit(module_data)
