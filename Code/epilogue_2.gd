extends Node2D

@onready var PShade = $PShadow
@onready var PNode = get_tree().get_first_node_in_group("player")

func _ready():
	PNode.position = Vector2(100,380)
	Globals.stoptime = true
	
	Globals.EndingHall = true
	Globals.NumTimesBeatGame += 1
	if Globals.SaveTime < Globals.BestTime or !Globals.BestTime:
		Globals.BestTime = Globals.SaveTime
	if Globals.NumDeaths < Globals.LDeaths or Globals.LDeaths == -1:
		Globals.LDeaths = Globals.NumDeaths
	Globals.save_game("user://perma.save",{
		"EBeer":Globals.EndingBeer,
		"EHall":Globals.EndingHall,
		"BGame":Globals.NumTimesBeatGame,
		"BestTime":Globals.BestTime,
		"LDeaths":Globals.LDeaths
		})
	Globals.SaveData(666)

func _process(delta):
	PShade.position.x = PNode.position.x 


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		$Henryk/Label.visible = true
		await get_tree().create_timer(3.0).timeout
		
		var time = Globals.sec_to_time(Globals.SaveTime)
		var hrs = "" if !time[2] else str(time[2]) + " hours "
		var min = "" if !time[1] else str(time[1]) + " minutes "
		
		$CanvasLayer2/Label2.text = "Final time: " + hrs + min + str(time[0]) + " seconds"
		$CanvasLayer2/Label2.visible = true
		$CanvasLayer2/Label.visible = true
		
		$CanvasLayer2/Label3.text = "You died: " + str(Globals.NumDeaths) + " times"
		$CanvasLayer2/Label3.visible = true
