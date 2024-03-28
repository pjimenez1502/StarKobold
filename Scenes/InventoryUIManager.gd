extends Control

@onready var credits_label = %CreditsLabel
@onready var scrap_label = %ScrapLabel
@onready var magnetics_label = %MagneticsLabel
@onready var electrical_label = %ElectricalLabel
@onready var blastproofs_label = %BlastproofsLabel
@onready var polyplastics_label = %PolyplasticsLabel


func _ready():
	Resources_Manager.RESOURCE_UPDATE.connect(update_resources)
	Resources_Manager.update_resource_signal()

func update_resources(resources):
	print(resources)
	credits_label.text = str(resources["credits"])
	scrap_label.text = str(resources["scrap"])
	magnetics_label.text = str(resources["magnetic_elements"])
	electrical_label.text = str(resources["electrical_components"])
	blastproofs_label.text = str(resources["blastproof_modules"])
	polyplastics_label.text = str(resources["polyplastics"])
