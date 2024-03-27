extends NavigationAgent3D

@export var character : CharacterBody3D

@export var target_distance := 0.2
var target_pos : Vector3

func _ready():
	path_desired_distance = 0.2
	target_desired_distance = target_distance

func _physics_process(delta):
	pathfind_and_move()

func pathfind_and_move():
	if is_navigation_finished():
		character.movement_finished()
		#print("fin")
		return
	
	var next_path_position = get_next_path_position()
	character.move_to_position(next_path_position)

func _on_pathfind_timeout():
	target_position = target_pos

func set_target_pos(position):
	target_position = position
