extends Node2D

func _ready():
	Globals.CArea = 2

func _on_main_place_gate_body_entered(body):
	if body.is_in_group("player"):
		get_tree().call_deferred("change_scene_to_file","res://Scenes/main.tscn")
		await get_tree().process_frame
		Globals.SetPlayerPos(Vector2(9532,-70))

func RESET():
	pass
