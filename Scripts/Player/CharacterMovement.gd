extends CharacterBody3D

const SPEED = 3.0
const JUMP_VELOCITY = 4.5

@onready var animation_player = $AnimationPlayer

func _physics_process(_delta):
	anim_process()

func movement_finished():
	velocity = Vector3.ZERO

func move_to_position(next_path_position):
	var direction = Vector3.ZERO
	
	direction = next_path_position - global_position
	direction = direction.normalized()
	
	velocity = direction * SPEED
	
	move_and_slide()

func anim_process():
	if velocity.length() > 2:
		animation_player.play("Walk")
	else:
		animation_player.stop()
