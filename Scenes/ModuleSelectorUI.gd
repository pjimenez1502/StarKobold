extends Control


@onready var CategoryButtons :Dictionary = {
	"1": $VBoxContainer/Categories/Category_1_Cockpits,
	"2": $VBoxContainer/Categories/Category_2_Power,
	"3": $VBoxContainer/Categories/Category_3_Thrust,
	"4": $VBoxContainer/Categories/Category_4_Cargo,
	"5": $VBoxContainer/Categories/Category_5_Hallway,
	"6": $VBoxContainer/Categories/Category_6_Habitation,
	"7": $VBoxContainer/Categories/Category_7_Hardpoint,
	"8": $VBoxContainer/Categories/Category_8_Utility,
}
@onready var module_list = $VBoxContainer/ModuleListContainer/ModuleList
@onready var category_label = %CategoryLabel
const EDITMODE_MODULE_SELECTOR = preload("res://Scenes/UI/editmode_module_selector.tscn")


func _ready():
	ModulesDataManager.module_selector_ui = self
	ModulesDataManager.select_category(1)

func highligh_active_category_button(category):
	for cat in CategoryButtons:
		CategoryButtons[cat].button_pressed = false
	var button = CategoryButtons[str(category)]
	button.button_pressed = true

func load_category(category):
	clear_module_list()
	var category_name = ModulesDataManager.categories.keys()[category-1]
	var modules = ModulesDataManager.get_modules_from_category(category_name)
	for module_id in modules:
		var module_data = ModulesDataManager.get_module_data(module_id)
	
		var module_button_instance = EDITMODE_MODULE_SELECTOR.instantiate()
		module_button_instance.ModulePressed.connect(select_module)
		module_list.add_child(module_button_instance)
		module_button_instance.set_data(module_data)
		
	category_label.text = category_name

func select_module(module_id):
	ModulesDataManager.select_module(module_id)

func clear_module_list():
	for module_button in module_list.get_children():
		module_button.ModulePressed.disconnect(select_module)
		module_button.queue_free()

func _on_category_button_pressed(category_id):
	highligh_active_category_button(category_id)
	ModulesDataManager.select_category(category_id)



