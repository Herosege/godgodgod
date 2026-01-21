extends Control


func _ready():
	Globals.stoptime = true
	Globals.TravelBack()

func _on_start_button_pressed():
	Globals.stoptime = false
	get_tree().change_scene_to_file("res://Scenes/main-postending.tscn")
