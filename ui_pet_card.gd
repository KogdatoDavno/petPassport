extends MarginContainer

@onready var name_label = $VBoxContainer/main_info/labels_container/name
@onready var breed_label = $VBoxContainer/main_info/labels_container/breed
@onready var sex_label = $VBoxContainer/main_info/labels_container/sex
@onready var date_label = $VBoxContainer/main_info/labels_container/date
@onready var color_label = $VBoxContainer/main_info/labels_container/color
@onready var chip_id_label = $VBoxContainer/main_info/labels_container/chip_id
@onready var passport_id_label = $VBoxContainer/main_info/labels_container/passport_id
@onready var suspects_text = $VBoxContainer/suspects_text
@onready var meds_history_grid = $VBoxContainer/meds_history
@onready var vaccination_history_grid = $VBoxContainer/vaccination_history
@onready var illness_history_grid = $VBoxContainer/illness_history



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_meds_pressed():
	meds_history_grid.show()
	vaccination_history_grid.hide()
	illness_history_grid.hide()
	suspects_text.hide()

func _on_vaccination_pressed():
	meds_history_grid.hide()
	vaccination_history_grid.show()
	illness_history_grid.hide()
	suspects_text.hide()

func _on_illness_pressed():
	meds_history_grid.hide()
	vaccination_history_grid.hide()
	illness_history_grid.show()
	suspects_text.hide()

func _on_suspects_pressed():
	meds_history_grid.hide()
	vaccination_history_grid.hide()
	illness_history_grid.hide()
	suspects_text.show()

func _on_add_meds_pressed():
	pass
