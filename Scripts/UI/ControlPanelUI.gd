extends Control

@onready var generator_entry_container = %GeneratorEntryContainer
@onready var powered_entry_container = %PoweredEntryContainer
@onready var hardpoints_entry_container = %HardpointsEntryContainer

var generator_list := []
var powered_list := []
var hardpoint_list := []

const CONTROL_PANEL_MODULE_ENTRY = preload("res://Scenes/UI/control_panel_module_entry.tscn")

enum CATEGORY {GENERATOR, POWERED, HARDPOINT}

func _ready():
	OverlaysManager.CONTROLPANEL_TOGGLE.connect(toggle_overlay_visible)
	
	OverlaysManager.ADD_CONTROLPANEL_GENERATOR_ENTRY.connect(add_generator_entry)
	OverlaysManager.ADD_CONTROLPANEL_POWERED_ENTRY.connect(add_powered_entry)
	OverlaysManager.ADD_CONTROLPANEL_HARDPOINT_ENTRY.connect(add_hardpoint_entry)
	
	OverlaysManager.REMOVE_CONTROLPANEL_GENERATOR_ENTRY.connect(remove_generator_entry)
	OverlaysManager.REMOVE_CONTROLPANEL_POWERED_ENTRY.connect(remove_powered_entry)
	OverlaysManager.REMOVE_CONTROLPANEL_HARDPOINT_ENTRY.connect(remove_hardpoint_entry)
	
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
	generator_list.append(entry_instance)

func add_powered_entry(module_data):
	var entry_instance = CONTROL_PANEL_MODULE_ENTRY.instantiate()
	powered_entry_container.add_child(entry_instance)
	entry_instance.fill_module_data(module_data)
	powered_list.append(entry_instance)

func add_hardpoint_entry(module_data):
	var entry_instance = CONTROL_PANEL_MODULE_ENTRY.instantiate()
	powered_entry_container.add_child(entry_instance)
	entry_instance.fill_module_data(module_data)
	hardpoint_list.append(entry_instance)

func remove_generator_entry(module_id):
	for entry in generator_list:
		if entry.module_id == module_id:
			generator_list.erase(entry)
			entry.queue_free()

func remove_powered_entry(module_id):
	for entry in powered_list:
		if entry.module_id == module_id:
			powered_list.erase(entry)
			entry.queue_free()

func remove_hardpoint_entry(module_id):
	for entry in hardpoint_list:
		if entry.module_id == module_id:
			hardpoint_list.erase(entry)
			entry.queue_free()
