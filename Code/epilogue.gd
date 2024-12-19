extends Node2D

func _ready():
	Globals.stoptime = true
	
	Globals.EndingBeer = true
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

func _on_s_timer_timeout():
	var time = Globals.sec_to_time(Globals.SaveTime)
	var hrs = "" if !time[2] else str(time[2]) + " hours "
	var min = "" if !time[1] else str(time[1]) + " minutes "
	
	$Label1.text = "Final time: " + hrs + min + str(time[0]) + " seconds"
	$Label1.visible = true
	$Label2.text = "You died: " + str(Globals.NumDeaths) + " times"
	$Label2.visible = true
	await get_tree().create_timer(3.2).timeout
	$music.stop()
