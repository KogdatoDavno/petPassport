extends Control

var change_scene = load("res://scenes/ui_catalog.tscn")
var framed_avatar_path = "user://petsPhotos/framed_avatar.data"

@onready var name_line : LineEdit = $MarginContainer/VBoxContainer/fields/GridContainer/name_line
@onready var age_dd_option : OptionButton = $MarginContainer/VBoxContainer/fields/GridContainer/age_line/DD
@onready var age_mm_option : OptionButton = $MarginContainer/VBoxContainer/fields/GridContainer/age_line/MM
@onready var age_yy_option : OptionButton = $MarginContainer/VBoxContainer/fields/GridContainer/age_line/YY
@onready var chip_id_serial : LineEdit = $MarginContainer/VBoxContainer/fields/GridContainer/chip_lines/chip_serial
@onready var chip_id_number : LineEdit = $MarginContainer/VBoxContainer/fields/GridContainer/chip_lines/chip_number
@onready var passport_id_serial : LineEdit =$MarginContainer/VBoxContainer/fields/GridContainer/passport_lines/passport_serial
@onready var passport_id_number : LineEdit =$MarginContainer/VBoxContainer/fields/GridContainer/passport_lines/passport_number
@onready var breed_line : LineEdit = $MarginContainer/VBoxContainer/fields/GridContainer/breed_line
@onready var color_line : LineEdit = $MarginContainer/VBoxContainer/fields/GridContainer/color_line
@onready var sex_m_picker : CheckBox = $MarginContainer/VBoxContainer/fields/GridContainer/sex_picker/m_picker
@onready var sex_f_picker : CheckBox = $MarginContainer/VBoxContainer/fields/GridContainer/sex_picker/f_picker
@onready var characteristics_field : TextEdit = $MarginContainer/VBoxContainer/fields/GridContainer/characteristics_field
@onready var fd_popup : FileDialog = $MarginContainer/VBoxContainer/fields/GridContainer/photo_picker/fd_popup
@onready var photo_path : Label = $MarginContainer/VBoxContainer/fields/GridContainer/photo_picker/photo_path
@onready var photo_rect = $MarginContainer/VBoxContainer/fields/GridContainer/photo_picker/photo_rect
@onready var important_label : Label = $MarginContainer/VBoxContainer/fields/important

# Called when the node enters the scene tree for the first time.
func _ready():
	set_properties_for_option_buttons()
	pass

func set_properties_for_option_buttons():
	var current_year = Time.get_date_dict_from_system()["year"] as int
	
	for i in 32:#здесь дни в месяцах +1
		if i > 0:
			age_dd_option.add_item(str(i))
		
	for i in 13:#здесь месяцы в году +1
		if i > 0:
			age_mm_option.add_item(str(i))
	
	for i in current_year + 1:
		if i > 1999:
			age_yy_option.add_item(str(i))
			
	age_dd_option.remove_item(0)#ремув нужен, потому что по умолчанию на нулевой индекс ставится пустой выбор
	age_mm_option.remove_item(0)
	age_yy_option.remove_item(0)

func upload_and_update_photo(path : String):
	#250 пикселей - это ширина квадрата картинки
	var new_image = Image.load_from_file(path)
	
	if new_image.get_height() > new_image.get_width():
		new_image.resize(250, 250*new_image.get_height()/new_image.get_width())
		new_image.crop(250,250)
	elif new_image.get_height() < new_image.get_width():
		new_image.resize(250*new_image.get_width()/new_image.get_height(), 250)
		new_image.crop(250,250)
	else :
		new_image.resize(250, 250)

	var new_texture = ImageTexture.create_from_image(new_image)
	photo_rect.set_texture(new_texture)
	SaveAndLoad.save_file_to_sys(framed_avatar_path, new_texture)



func _on_add_pet_pressed():
	var new_resource_path : String = ""

	var date_of_birth = {"year" : age_yy_option.get_item_text(age_yy_option.selected) as int, 
	"month" : age_mm_option.get_item_text(age_mm_option.selected) as int, 
	"day" : age_dd_option.get_item_text(age_dd_option.selected) as int}
	
	var sex = func():
		if sex_f_picker.button_pressed : return "жен"
		elif sex_m_picker.button_pressed : return "муж"
		else : return "undefiend"
	
	if !name_line.get_text().is_empty() and age_dd_option.selected != -1 and age_mm_option.selected != -1 and age_yy_option.selected != -1:
		
		if FileAccess.file_exists(framed_avatar_path):
			var framed_avatar_buffer = SaveAndLoad.load_file_from_sys(framed_avatar_path)
			new_resource_path = "user://petsPhotos/avatar_" + name_line.get_text() + ".data"
			if !(framed_avatar_buffer is ImageTexture):
				push_error("Cant load file buffer of a framed_avatar, framed_avatar is empty")
			else:
				SaveAndLoad.save_file_to_sys(new_resource_path, framed_avatar_buffer)
		else:
			push_error("Cant add pets avatar because of failure to find a framed_avatar")

		PetsData.add_pet(
			name_line.get_text(),
			breed_line.get_text(),
			sex.call(),
			date_of_birth,
			chip_id_serial.get_text(),
			chip_id_number.get_text(),
			passport_id_serial.get_text(),
			passport_id_number.get_text(),
			color_line.get_text(),
			characteristics_field.get_text(),
			new_resource_path
			)
		PetsData.save_data()
		get_tree().change_scene_to_packed(change_scene)
	else :
		important_label.add_theme_color_override("font_color", Color.ORANGE)
		push_error("не выбрали все обязательные поля")

func _on_return_pressed():
	get_tree().change_scene_to_packed(change_scene)

func _on_m_picker_pressed():
	if sex_f_picker.button_pressed:
		sex_f_picker.button_pressed = false

func _on_f_picker_pressed():
	if sex_m_picker.button_pressed:
		sex_m_picker.button_pressed = false

func _on_fd_button_pressed():
	fd_popup.show()

func _on_fd_popup_file_selected(path):
	upload_and_update_photo(path)
	photo_path.text = path.get_file()
