extends Node

var pet_name : String;
var breed : String;
var sex : String;
var date_of_birth : Array; #[DD,MM,YY]
var age : int;
var chip_id_serial : String;
var chip_id_number : String;
var passport_id_serial : String;
var passport_id_number : String;
var color : String;
var special_characteristics: String;
var avatar_path : String;

func set_new_pet(input_pet_name : String,
		input_breed : String,
		input_sex : String,
		input_date_of_birth : Array, 
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
	if today["month"] < date_of_birth[1] || (today["month"] == date_of_birth[1] and today["day"] < date_of_birth[0]) :
		age = today["year"] - date_of_birth[2] - 1 as int
	else :
		age = today["year"] - date_of_birth[2] as int
	
	chip_id_serial = input_chip_id_serial;
	chip_id_number = input_chip_id_number;
	passport_id_serial = input_passport_id_serial;
	passport_id_number = input_passport_id_number
	color = input_color;
	special_characteristics = input_special_characteristics;
	avatar_path = input_avatar_path;
	
	return [pet_name, breed, sex, date_of_birth, age, 
	chip_id_serial, chip_id_number, passport_id_serial, 
	passport_id_number, color, special_characteristics, avatar_path]
