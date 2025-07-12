extends Node2D

func _ready():
	Globals.CArea = 0 

func _on_main_place_gate_body_entered(body):
	if body.is_in_group("player"):
		Globals.SavedPos[0] = Vector2(9532,-70)
		get_tree().call_deferred("change_scene_to_file","res://Scenes/main.tscn")

func RESET():
	pass
