extends Node 

var save_path = "user://data/"
var save_name = "stored_data.tres"

var pets_dictionary : Dictionary = {}
#Индексы в словаре:
#pet_name, 0
#breed, 1
#sex, 2
#date_of_birth, 3
#age, 4
#chip_id_serial, 5
#chip_id_number, 6
#passport_id_serial, 7
#passport_id_number, 8
#color, 9
#special_characteristics, 10
#avatar_path, 11
#meds_history, 12
#vaccinations_history, 13
#illnes_history, 14

var meds_array : Array
var vaccination_array : Array
var illness_array : Array

var recent_data : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	load_data()

#скрипт для добавления животного нового
func add_pet(input_pet_name : String,
		input_breed : String,
		input_sex : String,
		input_date_of_birth : Dictionary, 
		input_chip_id_serial : String,
		input_chip_id_number : String,
		input_passport_id_serial : String,
		input_passport_id_number : String,
		input_color : String,
		input_special_characteristics : String,
		avatar_path : String):
		
	var db_id : String
	if !pets_dictionary.is_empty():
	#db_id работает так: берем весь массив ключей, забираем значение последнего ключа и прибавляем 1
		db_id = str(pets_dictionary.keys()[pets_dictionary.size() - 1] as int + 1)
	else :
		db_id = str(0)

	var new_pet = Pet.new().set_new_pet(input_pet_name,
		input_breed,
		input_sex,
		input_date_of_birth, 
		input_chip_id_serial,
		input_chip_id_number,
		input_passport_id_serial,
		input_passport_id_number,
		input_color,
		input_special_characteristics,
		avatar_path)
	#чтобы добавить запись в словарь, можно просто юзать
	pets_dictionary[db_id] = new_pet

func sort_elements_array(first : Dictionary, second : Dictionary):
	if Time.get_unix_time_from_datetime_dict(first["date"]) < Time.get_unix_time_from_datetime_dict(second["date"]):
		return true
	return false

#скрипт для удаления животного
func remove_pet(db_id : String):
	pets_dictionary.erase(db_id)
	save_data()

func add_pet_meds(db_id, date, type, med_name, additional):
	pets_dictionary[db_id][12].append(
		{
			"date" : date,
			"name" : med_name,
			"type" : type,
			"additional" : additional
		}
	)

func add_pet_vaccinations(db_id, date, _type, vacc_name, additional):
	pets_dictionary[db_id][13].append(
		{
			"date" : date,
			"name" : vacc_name,
			"additional" : additional
		}
	)
	
func add_pet_illnesses(db_id, date, _type, ill_name, additional):
	pets_dictionary[db_id][14].append(
		{
			"date" : date,
			"name" : ill_name,
			"additional" : additional
		}
	)
#скрипт для сохранения инфы о животных
func save_data():
	var json_dict : Dictionary = {
		"pets_dictionary" : pets_dictionary,
		"meds_array" : meds_array,
		"vaccination_array" : vaccination_array,
		"illness_array" : illness_array
	}
	SaveAndLoad.save_text_data(save_path + save_name, json_dict)

#скрипт для загрузки инфы о животных
func load_data():
	var data_buffer : Dictionary = SaveAndLoad.load_text_data(save_path + save_name, TYPE_DICTIONARY)
	
	if data_buffer.has("pets_dictionary"):
		pets_dictionary = data_buffer.get("pets_dictionary")
	if data_buffer.has("meds_array"):
		meds_array = data_buffer.get("meds_array")
	if data_buffer.has("vaccination_array"):
		vaccination_array = data_buffer.get("vaccination_array")
	if data_buffer.has("illness_array"):
		illness_array = data_buffer.get("illness_array")
	
