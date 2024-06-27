extends MarginContainer

var change_scene = load("res://scenes/ui_add_pet.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_add_pressed():
	get_tree().change_scene_to_packed(change_scene)
