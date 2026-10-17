extends Node2D

@onready var PNode = get_tree().get_first_node_in_group("player")


var AchCompleted := 0

const HARDMODE_ACH_REQ := 3

func _ready():
	Globals.stoptime = true
	SetSignText()
	
	#var Achs = $Achievements.get_children()
	#for i in Achs:
		#var AchID = i.Achiev_res.ID
		#if randf() > 0.0:
			#STEvents.Achievements[AchID].Achieved = true
			#i.UpdateVisual()
	
	SignalBus.GetInHouse.emit(true)
	PNode.global_position = Vector2(640,480)/2
	for i in STEvents.Achievements:
		if i.Achieved:
			AchCompleted += 1
	if AchCompleted >= 1:
		$"Stuff/GateHardmode/Gate/1".modulate = Color.RED
	if AchCompleted >= 2:
		$"Stuff/GateHardmode/Gate/2".modulate = Color.RED
	if AchCompleted >= 3:
		$Stuff/GateHardmode.queue_free()
	
	for i in STEvents.RombsGotten.size():
		if not $Stuff/Rombs.get_child(i):
			break
		
		$Stuff/Rombs.get_child(i).get_node("Sprite2D").visible = not STEvents.RombsGotten[i]
		$Stuff/Rombs.get_child(i).get_node("AnimatedSprite2D").visible = STEvents.RombsGotten[i]
	
	

func SetSignText():
	$Stuff/SignRombs.Text = "Rombs collected: {0}/{1}
	".format([STEvents.GetRombCAmnt(),STEvents.ROMBS_TOTAL_AMOUNT])

func _on_hard_mode_travel_to_body_entered(body):
	if body.is_in_group("player"):
		Globals.TravelBack()
		Globals.LoadScene("res://Scenes/traveling_intro.tscn")
