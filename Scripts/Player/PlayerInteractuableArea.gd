extends Area3D

@onready var interact_key_sprite = $"Interact_Key Sprite"

var interactuables_nearby : Array
var closest_interactuable

func _input(event):
	if event.is_action_pressed("Interact"):
		if closest_interactuable:
			closest_interactuable.interact()

func _physics_process(delta):
	if get_closest_interactuable():
		show_keysprite(true)
		place_keysprite_over_interactuable()
	else:
		show_keysprite(false)
	
var closest_distance : float
func get_closest_interactuable():
	if interactuables_nearby.size() == 0:
		return false
		
	closest_distance = INF
	for interactuable in interactuables_nearby:
		var dist_to_interactuable = (interactuable.global_position - position).length_squared()
		if dist_to_interactuable < closest_distance:
			closest_distance = dist_to_interactuable
			closest_interactuable = interactuable
	return true

func place_keysprite_over_interactuable():
	
	interact_key_sprite.global_position = closest_interactuable.global_position

func interactuable_entered(interactuable):
	interactuables_nearby.append(interactuable)

func interactuable_exited(interactuable):
	if interactuables_nearby.has(interactuable):
		interactuables_nearby.erase(interactuable)


func show_keysprite(value):
	interact_key_sprite.visible = value
