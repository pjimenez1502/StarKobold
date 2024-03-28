extends Control

@onready var credits_label = %CreditsLabel
@onready var scrap_label = %ScrapLabel

@onready var magnetics_label = %MagneticsLabel
@onready var electrical_label = %ElectricalLabel
@onready var baroplastics_label = %BaroplasticsLabel

@onready var blastproofs_label = %BlastproofsLabel


func _ready():
	OverlaysManager.INVENTORY_TOGGLE.connect(toggle_overlay_visible)
	
	Resources_Manager.RESOURCE_UPDATE.connect(update_resources)
	Resources_Manager.update_resource_signal()

func update_resources(resources):
	print(resources)
	credits_label.text = str(resources["credits"])
	scrap_label.text = str(resources["scrap"])
	magnetics_label.text = str(resources["magnetic_elements"])
	electrical_label.text = str(resources["electrical_components"])
	blastproofs_label.text = str(resources["blastproof_modules"])
	baroplastics_label.text = str(resources["baroplastics"])



func toggle_overlay_visible(value):
	match value:
		OverlaysManager.TOGGLE_EFFECT.OPEN:
			visible = true
			ControlFocusManager.switch_control_focus(ControlFocusManager.CONTROL_FOCUS.MENU)
		OverlaysManager.TOGGLE_EFFECT.CLOSE:
			visible = false
			ControlFocusManager.return_to_prev_focus()
		OverlaysManager.TOGGLE_EFFECT.TOGGLE:
			match visible:
				true:
					ControlFocusManager.return_to_prev_focus()
					visible = false
				false:
					ControlFocusManager.switch_control_focus(ControlFocusManager.CONTROL_FOCUS.MENU)
					visible = true
