extends Control


@onready var module_name = $MarginContainer/NinePatchRect/HBoxContainer/ModuleName
@onready var module_power = $MarginContainer/NinePatchRect/HBoxContainer/ModulePower
@onready var check_button = $MarginContainer/NinePatchRect/HBoxContainer/CheckButton

var module_id
var _module_data

func fill_module_data(module_data):
	module_id = module_data["module_inst_id"]
	_module_data = module_data
	
	module_name.text = module_data["module_name"]
	module_power.text = str(module_data["module"].power, " KWh")
	check_button.button_pressed = module_data["enabled"]

func toggle_module():
	_module_data["enabled"] = check_button.button_pressed
	Resources_Manager.SHIP_CALCULATE_POWER.emit()
	pass
