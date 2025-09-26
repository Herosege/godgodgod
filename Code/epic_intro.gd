extends Control

@onready var EM = $epicMUSIC

func _on_start_button_pressed():
	Globals.stoptime = false
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

var t = 0.0

func _ready():
	Globals.stoptime = true
	EM.pitch_scale = 0.2

func _process(delta):
	t+=delta
	if t > 0.1:
		t-=0.1
		EM.pitch_scale = (0.24 * (randf())+0.1)
	
