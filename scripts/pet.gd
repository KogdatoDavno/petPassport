class_name Pet extends Node

var pet_name : String;
var breed : String;
var sex : String;
var date_of_birth : Dictionary;
var age : int;
var chip_id_serial : String;
var chip_id_number : String;
var passport_id_serial : String;
var passport_id_number : String;
var color : String;
var special_characteristics: String;
var avatar_path : String;
var meds_history : Array[Dictionary];
var vaccinations_history : Array[Dictionary];
var illnes_history : Array[Dictionary];

func set_new_pet(input_pet_name : String,
		input_breed : String,
		input_sex : String,
		input_date_of_birth : Dictionary, 
		input_chip_id_serial : String,
		input_chip_id_number : String,
		input_passport_id_serial : String,
		input_passport_id_number : String,
		input_color : String,
		input_special_characteristics : String,
		input_avatar_path : String) -> Array:

	pet_name = input_pet_name;
	breed = input_breed;
	sex = input_sex;
	date_of_birth = input_date_of_birth;
	
	var today = Time.get_datetime_dict_from_system()
	if today["month"] < date_of_birth["month"] || (today["month"] == date_of_birth["month"] and today["day"] < date_of_birth["day"]) :
		age = today["year"] - date_of_birth["year"] - 1 as int
	else :
		age = today["year"] - date_of_birth["year"] as int
	
	chip_id_serial = input_chip_id_serial;
	chip_id_number = input_chip_id_number;
	passport_id_serial = input_passport_id_serial;
	passport_id_number = input_passport_id_number
	color = input_color;
	special_characteristics = input_special_characteristics;
	avatar_path = input_avatar_path;
	
	return [pet_name, breed, sex, date_of_birth, age, 
	chip_id_serial, chip_id_number, passport_id_serial, 
	passport_id_number, color, special_characteristics, avatar_path, 
	meds_history, vaccinations_history, illnes_history]
