extends Control

@onready var generator_entry_container = %GeneratorEntryContainer
@onready var powered_entry_container = %PoweredEntryContainer
@onready var hardpoints_entry_container = %HardpointsEntryContainer

const CONTROL_PANEL_MODULE_ENTRY = preload("res://Scenes/UI/control_panel_module_entry.tscn")

enum CATEGORY {GENERATOR, POWERED, HARDPOINT}

func _ready():
	OverlaysManager.CONTROLPANEL_TOGGLE.connect(toggle_overlay_visible)
	
	OverlaysManager.ADD_CONTROLPANEL_GENERATOR_ENTRY.connect(add_generator_entry)
	OverlaysManager.ADD_CONTROLPANEL_POWERED_ENTRY.connect(add_powered_entry)
	OverlaysManager.ADD_CONTROLPANEL_HARDPOINT_ENTRY.connect(add_hardpoint_entry)
	
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


func add_generator_entry(module_data):
	var entry_instance = CONTROL_PANEL_MODULE_ENTRY.instantiate()
	generator_entry_container.add_child(entry_instance)
	entry_instance.fill_module_data(module_data)

func add_powered_entry(module_data):
	var entry_instance = CONTROL_PANEL_MODULE_ENTRY.instantiate()
	powered_entry_container.add_child(entry_instance)
	entry_instance.fill_module_data(module_data)

func add_hardpoint_entry(module_data):
	var entry_instance = CONTROL_PANEL_MODULE_ENTRY.instantiate()
	powered_entry_container.add_child(entry_instance)
	entry_instance.fill_module_data(module_data)

func remove_entry(module):
	
	pass
