extends Node 

##DB_ID из-за дебильного JSONA пока сделан стрингом, хотя хранит число whatever

var pets_dictionary : Dictionary = {}
var meds_dictionary : Dictionary = {}
var vaccination_dictionary : Dictionary = {}
var illness_dictionary : Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	pets_dictionary = load_data()

#скрипт для добавления животного нового
func add_pet(input_pet_name : String,
		input_breed : String,
		input_sex : String,
		input_date_of_birth : Array, 
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

	var new_pet = Pet.set_new_pet(input_pet_name,
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
	printerr(pets_dictionary)

#скрипт для удаления животного
func remove_pet(db_id : String):
	pets_dictionary.erase(db_id)
	save_data()

#скрипт для сохранения инфы о животных
func save_data():
	var file = FileAccess.open("user://saved_data.json", FileAccess.WRITE)
	print(str(FileAccess.get_open_error()))
	var json_string = JSON.stringify(pets_dictionary, "\t")
	printerr(typeof(json_string))
	file.store_string(json_string)
	file.close()

#скрипт для загрузки инфы о животных - ГРУЗИТСЯ В ФОРМАТЕ СТРОКИ
func load_data():
	var json = JSON.new()
	
	if !FileAccess.file_exists("user://saved_data.json"):
		FileAccess.open("user://saved_data.json", FileAccess.WRITE)
		return {}
	else:
		var file = FileAccess.open("user://saved_data.json", FileAccess.READ)
		var data = json.parse(file.get_as_text())
		if data == OK:
			printerr(json.parse_string(file.get_as_text()))
			return json.parse_string(file.get_as_text())
		else : return {}
	
	
