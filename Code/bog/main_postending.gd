extends Node2D

@onready var PNode = get_tree().get_first_node_in_group("player")

func _ready():
	Globals.CArea = 6


func _process(delta):
	if PNode.CRoomPos == Vector2(1,0) and !STEvents.EventArray[STEvents.Enums.FTRottingFields]:
		STEvents.EventArray[STEvents.Enums.FTRottingFields] = true
		SignalBus.ShowAreaIntro.emit("Rotting fields")

func _on_gate_body_entered(body):
	if body.is_in_group("player"):
		Globals.PosSetTravel = Vector2(128,400)
		Globals.LoadScene("res://Scenes/scene_1-postending.tscn")

func _on_gate_area_area_entered(area):
	if area.is_in_group("damage"):
		$Stuff/GateBlocking.queue_free()

func RESET():
	pass
