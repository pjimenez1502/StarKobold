extends Node

@onready var player_ship = $".."
@onready var ship_builder = $"Ship Builder"
@onready var module_placer = $"Module Placer"

@onready var ship_grid_map = $"../NavigationRegion3D/ShipGridMap"

var selected_rotation_index : int = 0

func _ready():
	pass

func _physics_process(delta):
	if !ControlFocusManager.current_control_focus == ControlFocusManager.CONTROL_FOCUS.EDIT:
		show_module_preview(false)
		return
	show_module_preview(true)
	move_preview_to_mouse()

func _unhandled_input(event):
	if !ControlFocusManager.current_control_focus == ControlFocusManager.CONTROL_FOCUS.EDIT:
		return
	if event.is_action_pressed("RightClick"):
		right_click()
	if event.is_action_pressed("LeftClick"):
		left_click()
	
	if event.is_action_pressed("Rotate"):
		rotate()
	
	if event is InputEventKey:
		check_number_keys(event)

func check_number_keys(event):
	if event.is_action_pressed("1"):
		ModulesDataManager.select_category(1)
	if event.is_action_pressed("2"):
		ModulesDataManager.select_category(2)
	if event.is_action_pressed("3"):
		ModulesDataManager.select_category(3)
	if event.is_action_pressed("4"):
		ModulesDataManager.select_category(4)
	if event.is_action_pressed("5"):
		ModulesDataManager.select_category(5)
	if event.is_action_pressed("6"):
		ModulesDataManager.select_category(6)
	if event.is_action_pressed("7"):
		ModulesDataManager.select_category(7)
	if event.is_action_pressed("8"):
		ModulesDataManager.select_category(8)
	if event.is_action_pressed("0"):
		ModulesDataManager.select_all_category()

## END MANAGE CATEGORY AND MODULE SELECTION


## UTIL FUNCS
func right_click():
	var position = ship_grid_map.local_to_map(player_ship.to_local(get_mouse_pos()))
	ship_builder.remove_module(position)

func left_click():
	if !module_placer.can_place:
		return
	var position = ship_grid_map.local_to_map(player_ship.to_local(get_mouse_pos()))
	ship_builder.instantiate_module(ModulesDataManager.current_selected_module, position, selected_rotation_index)

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
