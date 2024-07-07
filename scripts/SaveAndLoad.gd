class_name SaveAndLoad extends Resource

const PASSWORD : String = "!data_password"

func _ready():
	print(PASSWORD)

static func save_file_to_sys(path : String, variant : Variant):
	if !FileAccess.file_exists(path):
		DirAccess.make_dir_absolute(path.get_base_dir())
	
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, PASSWORD)
	file.store_var(variant, true)
	file.close()

static func load_file_from_sys(path : String):
	if !FileAccess.file_exists(path):
		push_error("Cant find file on path ", path)
	else:
		var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, PASSWORD)
		var file_buffer = file.get_var(true)
		if !FileAccess.get_open_error():
			file.close()
			return file_buffer
		else:
			push_error("File is empty, result of opening file is ", FileAccess.get_open_error())

static func save_text_data(path : String, data):
	if !FileAccess.file_exists(path):
		DirAccess.make_dir_absolute(path.get_base_dir())
	
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, PASSWORD)
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	
static func load_text_data(path : String, type : int):

	if !FileAccess.file_exists(path):
		push_error("Cant find file on path ", path)
		var returned_var
		return type_convert(returned_var, type)
	else:
		var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, PASSWORD)
		var file_buffer = JSON.parse_string(file.get_as_text())
		file_buffer = type_convert(file_buffer, type)
		if !FileAccess.get_open_error() and type_string(typeof(file_buffer)) == type_string(type):
			file.close()
			return file_buffer
		else:
			push_error("File is empty, result of opening file is ", FileAccess.get_open_error())
