extends Node

@onready var player_ship = $".."

@onready var ship_builder = $"Ship Builder"
@onready var module_placer = $"Module Placer"

@onready var ship_grid_map = $"../NavigationRegion3D/ShipGridMap"


var current_category := 1
var current_selected_module
var selected_rotation_index : int = 0

func _ready():
	select_module("wall_01")

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
		if event.pressed and event.keycode == KEY_B:
			select_module("debug")
	
		check_section_selectors(event)
		check_number_keys(event)

func check_number_keys(event):
	match current_category:
		1:
			if event.is_action_pressed("1"):
				select_module("floor_01")
			if event.is_action_pressed("2"):
				select_module("wall_01")
			if event.is_action_pressed("3"):
				select_module("door_01")
		
		2:
			if event.is_action_pressed("1"):
				select_module("helmChair_01")
				
		3:
			if event.is_action_pressed("1"):
				select_module("mainthruster_01")
			if event.is_action_pressed("2"):
				select_module("manouverthruster_01")
		4:
			if event.is_action_pressed("1"):
				select_module("reactor_01")
		

func check_section_selectors(event):
	if event.is_action_pressed("Mod_1"): #HULL
		current_category = 1
	if event.is_action_pressed("Mod_2"): #SYSTEM
		current_category = 2
	if event.is_action_pressed("Mod_3"): #THRUST
		current_category = 3
	if event.is_action_pressed("Mod_4"): #POWER
		current_category = 4
	if event.is_action_pressed("Mod_5"): #HARDPOINT
		current_category = 5
	#print("Changed category to: ", current_category)



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


func select_module(id):
	module_placer.select_module(id)
	current_selected_module = id
	pass

func move_preview_to_mouse():
	var grid_mouse_pos = ship_grid_map.local_to_map(player_ship.to_local(get_mouse_pos()))
	var local_from_grid_mouse_pos = ship_grid_map.map_to_local(grid_mouse_pos)
	module_placer.move_preview(local_from_grid_mouse_pos)

func get_mouse_pos():
	var camera = get_viewport().get_camera_3d()
	var position2D = get_viewport().get_mouse_position()
	var dropPlane  = Plane(Vector3(0, 1, 0), 0.8)
	var position3D = dropPlane.intersects_ray(camera.project_ray_origin(position2D),camera.project_ray_normal(position2D))
	if !position3D:
		return Vector3.ZERO
	return position3D

func show_module_preview(value):
	module_placer.preview_mesh.visible = value
