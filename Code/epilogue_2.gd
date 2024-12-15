extends Node2D

@onready var PShade = $PShadow
@onready var PNode = get_tree().get_first_node_in_group("player")

func _ready():
	PNode.position = Vector2(100,380)
	Globals.stoptime = true
	
	Globals.EndingHall = true
	Globals.NumTimesBeatGame += 1
	Globals.save_game("user://perma.save",{
		"EBeer":Globals.EndingBeer,
		"EHall":Globals.EndingHall,
		"BGame":Globals.NumTimesBeatGame
		})

func _process(delta):
	PShade.position.x = PNode.position.x 


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		$Henryk/Label.visible = true
		await get_tree().create_timer(3.0).timeout
		$CanvasLayer2/Label2.text = "Final time: " + str(round(Globals.SaveTime*100)/100)
		$CanvasLayer2/Label2.visible = true
		$CanvasLayer2/Label.visible = true
