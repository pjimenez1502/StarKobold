extends Control


@onready var CategoryButtons = {
	1: $VBoxContainer/Categories/Category_1_Cockpits,
	2: $VBoxContainer/Categories/Category_2_Power,
	3: $VBoxContainer/Categories/Category_3_Thrust,
	4: $VBoxContainer/Categories/Category_4_Cargo,
	5: $VBoxContainer/Categories/Category_5_Hallway,
	6: $VBoxContainer/Categories/Category_6_Habitation,
	7: $VBoxContainer/Categories/Category_7_Hardpoint,
	8: $VBoxContainer/Categories/Category_8_Utility,
}
@onready var module_list = $VBoxContainer/ScrollContainer/ModuleList

func _ready():
	ModulesDataManager.module_selector_ui = self

func load_category(category):
	ModulesDataManager.module_references[category]
	pass


func _on_category_button_pressed(extra_arg_0):
	pass # Replace with function body.

