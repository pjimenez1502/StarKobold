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
	var module_data = ModulesDataManager.get_module_data(module_id)
	populate_moduledata_sheet(module_data)

func clear_module_list():
	for module_button in module_list.get_children():
		module_button.ModulePressed.disconnect(select_module)
		module_button.queue_free()

func _on_category_button_pressed(category_id):
	highligh_active_category_button(category_id)
	ModulesDataManager.select_category(category_id)


@onready var moduledata_name = %moduledata_name
@onready var moduledata_desc = %moduledata_desc
@onready var module_data_costlist = %"Module_Data Costlist"
@onready var module_data_statlist = %"Module_Data Statlist"

const MODULE_DATA_PAIR = preload("res://Scenes/UI/module_data_pair.tscn")

func populate_moduledata_sheet(module_data):
	moduledata_name.text = module_data.name
	moduledata_desc.text = module_data.desc
	
	clear_moduledata()
	for module_cost in module_data.costs:
		if module_data.costs[module_cost] != 0:
			var moduledata_instance = MODULE_DATA_PAIR.instantiate()
			module_data_costlist.add_child(moduledata_instance)
			moduledata_instance.set_data(module_cost, module_data.costs[module_cost])
	
	for module_stat in module_data.stats:
		if module_data.stats[module_stat] != 0:
			var moduledata_instance = MODULE_DATA_PAIR.instantiate()
			module_data_statlist.add_child(moduledata_instance)
			moduledata_instance.set_data(module_stat, module_data.stats[module_stat])

func clear_moduledata():
	for cost in module_data_costlist.get_children():
		cost.queue_free()
	for stat in module_data_statlist.get_children():
		stat.queue_free()
