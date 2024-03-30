extends Control


## STATS
@onready var ship_mass_label = %ShipMassLabel
@onready var ship_power_label = %ShipPowerLabel


## RESOURCES
@onready var scrap_label = %ScrapEditLabel
@onready var magnetics_label = %MagneticsEditLabel
@onready var electrical_label = %ElectricalEditLabel
@onready var baroplastics_label = %BaroplasticsEditLabel
@onready var blastproofs_label = %BlastproofsEditLabel
@onready var semiconductives_label = %SemiconductivesEditLabel

func _ready():
	OverlaysManager.EDIT_TOGGLE.connect(toggle_overlay_visible)
	
	Resources_Manager.RESOURCE_UPDATE.connect(update_resources)
	Resources_Manager.update_resource_signal()
	
	Resources_Manager.SHIP_STAT_UPDATE.connect(update_ship_stats)
	

func update_resources(resources):
	#print(resources)
	scrap_label.text = str(resources["scrap"])
	
	magnetics_label.text = str(resources["magnetic_elements"])
	electrical_label.text = str(resources["electrical_components"])
	baroplastics_label.text = str(resources["baroplastic_segments"])
	
	blastproofs_label.text = str(resources["blastproof_modules"])
	semiconductives_label.text = str(resources["semiconductive_fibers"])
	#blastproofs_label.text = str(resources["blastproof_modules"])

func update_ship_stats(stats):
	print("updatingstats")
	ship_mass_label.text = str(stats["mass"], " T")
	ship_power_label.text = str(stats["drained_power"], "/", stats["available_power"], " MWh")
	
func toggle_overlay_visible(value):
	visible = value


