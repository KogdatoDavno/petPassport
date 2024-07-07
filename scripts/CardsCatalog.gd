class_name Catalog extends MarginContainer

@onready var cards_container = $ScrollContainer/CardsContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	if !PetsData.pets_dictionary.is_empty():
		
		var reverse_order_keys = PetsData.pets_dictionary.keys()
		reverse_order_keys.reverse()
		
		for key in reverse_order_keys:
			var pet_data = PetsData.pets_dictionary[key]
			var new_card = load("res://scenes/ui_catalog_card.tscn")
			var instance = new_card.instantiate()
			instance.create(
				pet_data[0],  # input_pet_name
				pet_data[4],  # age
				str(pet_data[5], " ", pet_data[6]),  # input_chip_id
				str(pet_data[7], " ", pet_data[8]),  # input_passport_id
				key as String,      # input_db_id
				pet_data[11]#avatar_path
			)
			cards_container.add_child(instance)
