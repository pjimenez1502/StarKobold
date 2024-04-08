extends HBoxContainer

#@onready var texture_rect = $TextureRect
@onready var resource = $resource
@onready var ammount = $ammount

func set_data(_resource, value):
	#texture_rect.texture = image
	resource.text = _resource
	ammount.text = str(value)
