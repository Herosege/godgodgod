extends Node2D

func _ready():
	Globals.stoptime = true
	
	Globals.EndingBeer = true
	Globals.NumTimesBeatGame += 1
	Globals.save_game("user://perma.save",{
		"EBeer":Globals.EndingBeer,
		"EHall":Globals.EndingHall,
		"BGame":Globals.NumTimesBeatGame
		})

func _on_s_timer_timeout():
	$Label1.text = "Final time: " + str(round(Globals.SaveTime*100)/100)
	$Label1.visible = true
	
	await get_tree().create_timer(3.2).timeout
	$music.stop()
