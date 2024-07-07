class_name CatalogCard extends HBoxContainer

@onready var label_pet_name = $label_container/Name
@onready var label_pet_age = $label_container/Age
@onready var label_chip_id = $label_container/Chip_ID
@onready var label_passport_id = $label_container/Passport_ID
@onready var photo = $photo_panel/photo

var pet_name : String;
var pet_age : int;
var chip_id : String;
var passport_id : String;
var db_id : String;
var avatar_path : String

var change_scene = load("res://scenes/ui_pet_card.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	label_pet_name.set_text(pet_name)
	label_pet_age.set_text("Возраст: " + str(pet_age))
	label_chip_id.set_text("ID чипа: " + str(chip_id))
	label_passport_id.set_text("ID пасспорта: " + str(passport_id))
	
	if FileAccess.file_exists(avatar_path):
		var load_photo = SaveAndLoad.load_file_from_sys(avatar_path)
		
		if load_photo is ImageTexture:
			photo.set_texture(load_photo)
		else:
			printerr("Unable to load photo for pet ", pet_name)
	else: 
		printerr("Path ", avatar_path, "doesn't contain ImageTexture for pet ", pet_name)
	
	
func create(input_pet_name : String, input_age : int, 
	input_chip_id : String, input_passport_id : String, input_db_id : String,
	resource : String):
	
	pet_name = input_pet_name
	pet_age = input_age
	chip_id = input_chip_id
	passport_id = input_passport_id
	db_id = input_db_id
	if resource == "":
		printerr("No such photo for pet ", pet_name)
	else:
		avatar_path = resource

func _on_delete_card_pressed():
	if ResourceLoader.exists(PetsData.pets_dictionary[db_id][11]):
		DirAccess.remove_absolute(PetsData.pets_dictionary[db_id][11])
	PetsData.remove_pet(db_id)
	PetsData.save_data()
	get_parent().remove_child(self)
	self.queue_free()

func _on_open_card_pressed():
	PetsData.recent_data = PetsData.pets_dictionary[db_id].duplicate()
	PetsData.recent_data.append(db_id)
	get_tree().change_scene_to_packed(change_scene)
