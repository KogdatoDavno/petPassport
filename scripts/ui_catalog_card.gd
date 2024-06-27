class_name CatalogCard extends HBoxContainer

@onready var label_pet_name = $label_container/Name
@onready var label_pet_age = $label_container/Age
@onready var label_chip_id = $label_container/Chip_ID
@onready var label_passport_id = $label_container/Passport_ID
@onready var label_db_id = $label_container/DB_ID
@onready var photo = $photo

var pet_name : String;
var pet_age : int;
var chip_id : String;
var passport_id : String;
var db_id : String;
var avatar_path : String


# Called when the node enters the scene tree for the first time.
func _ready():
	label_pet_name.set_text("Name: " + pet_name)
	label_pet_age.set_text("Age: " + str(pet_age))
	label_chip_id.set_text("Chip ID: " + str(chip_id))
	label_passport_id.set_text("Passport ID: " + str(passport_id))
	label_db_id.set_text("DB ID: " + str(db_id))
	photo.set_texture(load(avatar_path))
	
	
	
func create(input_pet_name : String, input_age : int, 
	input_chip_id : String, input_passport_id : String, input_db_id : String,
	resource : String):
	
	pet_name = input_pet_name
	pet_age = input_age
	chip_id = input_chip_id
	passport_id = input_passport_id
	db_id = input_db_id
	avatar_path = resource

func _on_delete_card_pressed():
	PetsData.remove_pet(db_id)
	PetsData.save_data()
	get_parent().remove_child(self)
	self.queue_free()


