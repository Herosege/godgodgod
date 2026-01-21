extends Node2D

func _ready():
	Globals.CArea = 6


func _on_gate_body_entered(body):
	if body.is_in_group("player"):
		Globals.PosSetTravel = Vector2(128,400)
		Globals.LoadScene("res://Scenes/scene_1-postending.tscn")

func _on_gate_area_area_entered(area):
	if area.is_in_group("damage"):
		$Stuff/GateBlocking.queue_free()

func RESET():
	pass
