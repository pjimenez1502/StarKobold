extends Node

var module_references = {
		"COCKPIT": {
			1: ["cockpit_small_01"],
		},
		"POWER":{
			1: ["reactor_01"]
		},
		"THRUSTER":{
			1: ["thruster_main_small_01"]
		},
		"CARGO":{
			1: ["cargo_small_01"],
			2: ["fuel_small_01"],
		},
		"HALLWAY":{
			1: ["hallway_01", "hallway_01_corner", "hallway_01_X"]
		},
		"HABITATION":{
			
		},
		"HARDPOINT":{
			
		},
		"UTILITY":{
			
		}
	}

@onready var player_ship = $".."

@onready var ship_builder = $"Ship Builder"
@onready var module_placer = $"Module Placer"

@onready var ship_grid_map = $"../NavigationRegion3D/ShipGridMap"


var current_category := "COCKPIT"
var current_selected_module
var selected_rotation_index : int = 0

func _ready():
	select_module(["COCKPIT",1])

func _physics_process(delta):
	if !ControlFocusManager.current_control_focus == ControlFocusManager.CONTROL_FOCUS.EDIT:
		show_module_preview(false)
		return
	show_module_preview(true)
	move_preview_to_mouse()

func _input(event):
	if !ControlFocusManager.current_control_focus == ControlFocusManager.CONTROL_FOCUS.EDIT:
		return
	if event.is_action_pressed("RightClick"):
		right_click()
	if event.is_action_pressed("LeftClick"):
		left_click()
	
	if event.is_action_pressed("Rotate"):
		rotate()
	
	if event is InputEventKey:
		if !check_section_selectors(event):
			check_number_keys(event)
		else:
			print("Changed category to: ", current_category)
			select_module([current_category,1])

## MANAGE CATEGORY AND MODULE SELECTION
func check_section_selectors(event):
	if event.is_action_pressed("Mod_1"):
		if !current_category == "COCKPIT":
			current_category = "COCKPIT"
			return true
	if event.is_action_pressed("Mod_2"):
		if !current_category == "POWER":
			current_category = "POWER"
			return true
	if event.is_action_pressed("Mod_3"):
		if !current_category == "THRUSTER":
			current_category = "THRUSTER"
			return true
	if event.is_action_pressed("Mod_4"):
		if !current_category == "CARGO":
			current_category = "CARGO"
			return true
	if event.is_action_pressed("Mod_5"):
		if !current_category == "HALLWAY":
			current_category = "HALLWAY"
			return true
	if event.is_action_pressed("Mod_6"):
		if !current_category == "HARDPOINT":
			current_category = "HALLWAY"
			return true
	if event.is_action_pressed("Mod_7"):
		if !current_category == "HARDPOINT":
			current_category = "HARDPOINT"
			return true
	if event.is_action_pressed("Mod_7"):
		if !current_category == "UTILITY":
			current_category = "UTILITY"
			return true
	return false

func check_number_keys(event):
	if event.is_action_pressed("1"):
		select_module([current_category,1])
	if event.is_action_pressed("2"):
		select_module([current_category,2])
	if event.is_action_pressed("3"):
		select_module([current_category,3])
	if event.is_action_pressed("4"):
		select_module([current_category,4])
	if event.is_action_pressed("5"):
		select_module([current_category,5])
	if event.is_action_pressed("6"):
		select_module([current_category,6])
	if event.is_action_pressed("7"):
		select_module([current_category,7])
	if event.is_action_pressed("8"):
		select_module([current_category,8])
	if event.is_action_pressed("9"):
		select_module([current_category,9])

var selected_variant_index := 0
var current_selected_index : Array
func select_module(selected_index):
	var category = module_references[selected_index[0]]
	if !category.has(selected_index[1]):
		return
	var variants = category[selected_index[1]]
		
	if current_selected_index == selected_index:
		selected_variant_index = (selected_variant_index + 1) % variants.size()
	else:
		current_selected_index = selected_index
		selected_variant_index = 0
		
	var id = variants[selected_variant_index]
	
	print(id)
	module_placer.select_module(id)
	current_selected_module = id

## END MANAGE CATEGORY AND MODULE SELECTION




func right_click():
	var position = ship_grid_map.local_to_map(player_ship.to_local(get_mouse_pos()))
	ship_builder.remove_module(position)

func left_click():
	if !module_placer.can_place:
		return
	var position = ship_grid_map.local_to_map(player_ship.to_local(get_mouse_pos()))
	ship_builder.instantiate_module(current_selected_module, position, selected_rotation_index)

func rotate():
	selected_rotation_index = (selected_rotation_index + 1) % 4
	module_placer.set_rotation(selected_rotation_index)
	#print("rot index: ", selected_rotation_index)

func move_preview_to_mouse():
	var grid_mouse_pos = ship_grid_map.local_to_map(player_ship.to_local(get_mouse_pos()))
	var local_from_grid_mouse_pos = ship_grid_map.map_to_local(grid_mouse_pos)
	module_placer.move_preview(local_from_grid_mouse_pos)

func show_module_preview(value):
	module_placer.preview_mesh.visible = value



func get_mouse_pos():
	var camera = get_viewport().get_camera_3d()
	var position2D = get_viewport().get_mouse_position()
	var dropPlane  = Plane(Vector3(0, 1, 0), 0.8)
	var position3D = dropPlane.intersects_ray(camera.project_ray_origin(position2D),camera.project_ray_normal(position2D))
	if !position3D:
		return Vector3.ZERO
	return position3D
