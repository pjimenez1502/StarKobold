extends Button

signal ModulePressed

@onready var module_name_label = %ModuleNameLabel
@onready var module_portrait = %ModulePortrait
var module_data

func set_data(_module_data):
	module_data = _module_data
	module_name_label.text = _module_data.name

func _on_pressed():
	ModulePressed.emit(module_data.id)
