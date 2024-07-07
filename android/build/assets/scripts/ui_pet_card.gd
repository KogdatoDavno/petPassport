class_name PetCard extends Control

enum TYPE {
	MEDS,
	VACCINATIONS,
	ILLNESSES
}

var meds_history_data : Array
var vacc_history_data : Array
var ill_history_data : Array
var called_type
var db_id
var change_scene = load("res://scenes/ui_catalog.tscn")

@onready var name_label = $MarginContainer/VBoxContainer/main_info/labels_container/name
@onready var breed_label = $MarginContainer/VBoxContainer/main_info/labels_container/breed
@onready var sex_label = $MarginContainer/VBoxContainer/main_info/labels_container/sex
@onready var date_label = $MarginContainer/VBoxContainer/main_info/labels_container/date
@onready var color_label = $MarginContainer/VBoxContainer/main_info/labels_container/color
@onready var chip_id_label = $MarginContainer/VBoxContainer/main_info/labels_container/chip_id
@onready var passport_id_label = $MarginContainer/VBoxContainer/main_info/labels_container/passport_id
@onready var suspects_text = $MarginContainer/VBoxContainer/suspects_text
@onready var meds_history_grid = $MarginContainer/VBoxContainer/ScrollContainer/grids_control/meds_history
@onready var vaccination_history_grid = $MarginContainer/VBoxContainer/ScrollContainer/grids_control/vaccination_history
@onready var illness_history_grid = $MarginContainer/VBoxContainer/ScrollContainer/grids_control/illness_history
@onready var avatar_rect = $MarginContainer/VBoxContainer/main_info/photo_container/photo
@onready var grid_tag_and_button = $MarginContainer/VBoxContainer/grid_tag_and_button
@onready var grid_tag = $MarginContainer/VBoxContainer/grid_tag_and_button/top_bar/grid_tag
@onready var meds_grid_button = $MarginContainer/VBoxContainer/med_info_buttons/box1/meds

#add_grid_cells_window
@onready var add_grid_cells_window = $MarginContainer/VBoxContainer/adding_grid_cells_window
@onready var cells_type_label = $MarginContainer/VBoxContainer/adding_grid_cells_window/MarginContainer/VBoxContainer/cells_type_label
@onready var dd_option = $MarginContainer/VBoxContainer/adding_grid_cells_window/MarginContainer/VBoxContainer/date_line/DD
@onready var mm_option = $MarginContainer/VBoxContainer/adding_grid_cells_window/MarginContainer/VBoxContainer/date_line/MM
@onready var yy_option = $MarginContainer/VBoxContainer/adding_grid_cells_window/MarginContainer/VBoxContainer/date_line/YY
@onready var treatment_label = $MarginContainer/VBoxContainer/adding_grid_cells_window/MarginContainer/VBoxContainer/treatment_label
@onready var treatment_option = $MarginContainer/VBoxContainer/adding_grid_cells_window/MarginContainer/VBoxContainer/treatment_option2
@onready var additional = $MarginContainer/VBoxContainer/adding_grid_cells_window/MarginContainer/VBoxContainer/additional_line
@onready var add_grid_cells_option = $MarginContainer/VBoxContainer/adding_grid_cells_window/MarginContainer/VBoxContainer/add_grid_cells_option
@onready var add_grid_cells_line_option = $MarginContainer/VBoxContainer/adding_grid_cells_window/MarginContainer/VBoxContainer/add_grid_cells_line_option

func _ready():
	db_id = PetsData.recent_data[PetsData.recent_data.size() - 1]
	add_grid_cells_window.set_size(Vector2i(get_parent_area_size().x as int, 300))
	
	name_label.text = PetsData.recent_data[0]
	breed_label.text = PetsData.recent_data[1]
	sex_label.text += PetsData.recent_data[2]
	date_label.text += str(PetsData.recent_data[3]["day"], ".", PetsData.recent_data[3]["month"], ".", PetsData.recent_data[3]["year"])
	color_label.text += PetsData.recent_data[9]
	chip_id_label.text += str(PetsData.recent_data[5]) + " " + str(PetsData.recent_data[6])
	passport_id_label.text += str(PetsData.recent_data[7]) + " " + str(PetsData.recent_data[8])
	suspects_text.text += PetsData.recent_data[10]
	
	meds_grid_button.emit_signal("pressed")
	update_grid(TYPE.MEDS)
	update_grid(TYPE.VACCINATIONS)
	update_grid(TYPE.ILLNESSES)
	
	avatar_rect.set_texture(SaveAndLoad.load_file_from_sys(PetsData.recent_data[11]))
	
	var current_year = Time.get_date_dict_from_system()["year"] as int
	
	for i in current_year + 1:
		if i > 1999: yy_option.add_item(str(i))
	
	yy_option.remove_item(0)

#Обновление информации в таблицах
func update_grid(type : int):
	var history_grid
	var history_data : Array
	var indexes_number : int = 3
	var counter : int = 0

	match type:
		TYPE.MEDS:
			history_grid = meds_history_grid
			history_data = PetsData.recent_data[12].duplicate()
			history_data.reverse()
			indexes_number = 4
			
		TYPE.VACCINATIONS:
			history_grid = vaccination_history_grid
			history_data = PetsData.recent_data[13].duplicate()
			history_data.reverse()
			
		TYPE.ILLNESSES:
			history_grid = illness_history_grid
			history_data = PetsData.recent_data[14].duplicate()
			history_data.reverse()
	
	for child in history_grid.get_children():
		history_grid.remove_child(child)
		child.queue_free()
	
	for element in history_data:
		counter += 1
		
		var grid_num_label : Label = Label.new()
		var grid_date_label : Label = Label.new()
		var grid_name_label : Label = Label.new()
		var grid_type_label : Label = Label.new()
		var grid_additional_label : Label = Label.new()
		
		grid_num_label.custom_minimum_size.x = 35
		grid_date_label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		grid_name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		grid_name_label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		grid_type_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		grid_type_label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		grid_additional_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		grid_additional_label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		
		grid_num_label.text = str(counter)
		history_grid.add_child(grid_num_label)
		grid_date_label.text = str(element["date"]["day"], ".", element["date"]["month"], ".", element["date"]["year"])
		history_grid.add_child(grid_date_label)
		grid_name_label.text = element["name"]
		history_grid.add_child(grid_name_label)
		if type == TYPE.MEDS:
			grid_type_label.text = element["type"]
			history_grid.add_child(grid_type_label)
		grid_additional_label.text = element["additional"]
		history_grid.add_child(grid_additional_label)

func _on_meds_pressed():
	called_type = TYPE.MEDS
	grid_tag.text = "История обработок"
	grid_tag_and_button.show()
	meds_history_grid.show()
	grid_tag_and_button.get_child(1).show()
	grid_tag_and_button.get_child(2).hide()
	grid_tag_and_button.get_child(3).hide()
	vaccination_history_grid.hide()
	illness_history_grid.hide()
	suspects_text.hide()

func _on_vaccination_pressed():
	called_type = TYPE.VACCINATIONS
	grid_tag.text = "История вакцинаций"
	grid_tag_and_button.show()
	vaccination_history_grid.show()
	grid_tag_and_button.get_child(1).hide()
	grid_tag_and_button.get_child(2).show()
	grid_tag_and_button.get_child(3).hide()
	meds_history_grid.hide()
	illness_history_grid.hide()
	suspects_text.hide()

func _on_illness_pressed():
	called_type = TYPE.ILLNESSES
	grid_tag.text = "История болезней"
	grid_tag_and_button.show()
	illness_history_grid.show()
	grid_tag_and_button.get_child(1).hide()
	grid_tag_and_button.get_child(2).hide()
	grid_tag_and_button.get_child(3).show()
	meds_history_grid.hide()
	vaccination_history_grid.hide()
	suspects_text.hide()

func _on_suspects_pressed():
	grid_tag_and_button.hide()
	meds_history_grid.hide()
	vaccination_history_grid.hide()
	illness_history_grid.hide()
	suspects_text.show()

func _on_return_pressed():
	PetsData.recent_data.clear()
	get_tree().change_scene_to_packed(change_scene)

#ДАЛЕЕ ФУНКЦИИ ВСПЛЫВАЮЩИХ ОКОН
#коллед фром нужен, чтобы обновить содержимое всплывающего окна
func called_from(type : int):
	called_type = type
	add_grid_cells_option.clear()
	add_grid_cells_option.add_item("+ Добавить запись", 0)
	add_grid_cells_option.select(-1)
	
	match type :
		TYPE.MEDS :
			cells_type_label.text = "Название препарата"
			
			treatment_label.show()
			treatment_option.show()
			
			if !PetsData.meds_array.is_empty():
				for med in PetsData.meds_array: add_grid_cells_option.add_item(med)

		TYPE.VACCINATIONS : 
			cells_type_label.text = "Название вакцинации"
			
			treatment_label.hide()
			treatment_option.hide()
			
			if !PetsData.vaccination_array.is_empty():
				for vacc in PetsData.vaccination_array: add_grid_cells_option.add_item(vacc)

		TYPE.ILLNESSES : 
			cells_type_label.text = "Название болезни"
			
			treatment_label.hide()
			treatment_option.hide()
			
			if !PetsData.illness_array.is_empty():
				for ill in PetsData.illness_array: add_grid_cells_option.add_item(ill)

func _on_accept_pressed():
	var data_buffer : Array
	var callable : Callable
	var update_func : Callable = Callable(self, "update_grid")

	var choosen_date = func() -> Dictionary:
		if dd_option.selected != -1 and mm_option.selected != -1 and yy_option.selected != -1:
			return {"day" : dd_option.get_item_text(dd_option.selected) as int, 
			"month" : mm_option.get_item_text(mm_option.selected) as int, 
			"year" : yy_option.get_item_text(yy_option.selected) as int}
		else:
			push_error("Date hasn't been chosen")
			return {}
	
	var choosen_parameter = func() -> String:
		if add_grid_cells_option.selected > 0:
			return add_grid_cells_option.get_item_text(add_grid_cells_option.selected)
		else:
			push_error("Parameter hasn't been chosen")
			return ""
	
	var choosen_type = func() -> String:
		if treatment_option.selected != -1:
			return treatment_option.get_item_text(treatment_option.selected)
		else:
			push_warning("Type hasn't been chosen, is it necessary?")
			return ""

	var choosen_additional = additional.text

	match called_type:
		TYPE.MEDS:
			data_buffer = PetsData.pets_dictionary[db_id][12]
			callable = Callable(PetsData, "add_pet_meds")
		TYPE.VACCINATIONS:
			data_buffer = PetsData.pets_dictionary[db_id][13]
			callable = Callable(PetsData, "add_pet_vaccinations")
		TYPE.ILLNESSES:
			data_buffer = PetsData.pets_dictionary[db_id][14]
			callable = Callable(PetsData, "add_pet_illnesses")
	
	if !choosen_date.call().is_empty() and !choosen_parameter.call().is_empty():
		callable.call(db_id, choosen_date.call(), choosen_type.call(), choosen_parameter.call(), choosen_additional)
		data_buffer.sort_custom(PetsData.sort_elements_array)
		print("array sorted")
		PetsData.save_data()
		update_func.call(called_type)
		add_grid_cells_window.hide()
		add_grid_cells_option.select(-1)
		add_grid_cells_line_option.get_child(0).text = ""
		treatment_option.select(-1)
		dd_option.select(-1)
		mm_option.select(-1)
		yy_option.select(-1)
		additional.text = ""
	else:
		push_error("Required fields are not selected")

func _on_cancel_pressed():
	add_grid_cells_option.select(-1)
	add_grid_cells_line_option.get_child(0).text = ""
	treatment_option.select(-1)
	dd_option.select(-1)
	mm_option.select(-1)
	yy_option.select(-1)
	additional.text = ""
	add_grid_cells_line_option.hide()
	add_grid_cells_window.hide()

#обработка, какой пункт выбран в options: если 0 - то надо добавить запись
func _on_add_grid_cells_option_item_selected(index):
	if index == 0 && !add_grid_cells_line_option.visible:
		add_grid_cells_line_option.show()

#сигнал от кнопки для добавления новой опции в список опций
func _on_add_input_pressed():
	var data_buffer

	match called_type:
		TYPE.MEDS:
			data_buffer = PetsData.meds_array
		TYPE.VACCINATIONS:
			data_buffer = PetsData.vaccination_array
		TYPE.ILLNESSES:
			data_buffer = PetsData.illness_array
	
	data_buffer.append(add_grid_cells_line_option.get_child(0).text)
	add_grid_cells_option.add_item(data_buffer[data_buffer.size() - 1])
	add_grid_cells_option.select(add_grid_cells_option.item_count - 1)
	PetsData.save_data()
	add_grid_cells_line_option.get_child(0).text = ""
	add_grid_cells_line_option.hide()

func _on_call_popup_pressed():
	called_from(called_type)
	add_grid_cells_window.show()
