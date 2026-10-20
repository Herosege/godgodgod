extends Control

@onready var EM = $epicMUSIC

func _on_start_button_pressed():
	Globals.stoptime = false
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

var t = 0.0

func _ready():
	Globals.stoptime = true

func _process(delta):
	pass
