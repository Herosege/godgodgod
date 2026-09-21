extends Node2D

@onready var PNode = get_tree().get_first_node_in_group("player")



func _ready():
	SignalBus.GetInHouse.emit(true)
	PNode.global_position = Vector2(640,480)/2
	
	
	#var Achs = $Achievements.get_children()
	#for i in Achs:
		#var AchID = i.Achiev_res.ID
		#if STEvents.Achievements[AchID].Achieved:
			#pass
