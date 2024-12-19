extends Control

func _ready():
	Globals.stoptime = true
	AudioServer.set_bus_volume_db(0,(Globals.MVol/4)-15)
	AudioServer.set_bus_mute(0,!Globals.MVol)
	AudioServer.set_bus_volume_db(1,(Globals.SEVol/4)-15)
	AudioServer.set_bus_mute(1,!Globals.SEVol)
	
	Globals.EndingBeer = Globals.load_game("user://perma.save","EBeer",Globals.EndingBeer)
	Globals.EndingHall = Globals.load_game("user://perma.save","EHall",Globals.EndingHall)
	Globals.NumTimesBeatGame = Globals.load_game("user://perma.save","BGame",Globals.NumTimesBeatGame)
	Globals.BestTime = Globals.load_game("user://perma.save","BestTime",Globals.BestTime)
	Globals.LDeaths = Globals.load_game("user://perma.save","LDeaths",Globals.LDeaths)
	
	Globals.NumDeaths = Globals.load_game("user://dinomemories.save","NumDeaths",Globals.NumDeaths)
	
	if Globals.NumTimesBeatGame:
		$Label4.visible = true
		$Label4.text = "You beat the game " + str(Globals.NumTimesBeatGame) + " times!"
		$Label5.visible = true
		
		var time = Globals.sec_to_time(Globals.BestTime)
		var hrs = "" if !time[2] else str(time[2]) + " hours "
		var min = "" if !time[1] else str(time[1]) + " minutes "
		
		$Label5.text = "Your awesome best time:\n" + hrs+min+str(time[0]) +" seconds"
	
	if Globals.LDeaths != -1:
		$Says.visible = true
		$Says/Label.text = "I can beat the game with\nonly " + str(Globals.LDeaths) + " deaths!!!" if Globals.LDeaths > 0 else "I am the one true god!"
	
	$Trophies/TextureRect.visible = Globals.EndingHall
	$Trophies/TextureRect2.visible = Globals.EndingBeer

var DelSaveCount = 0

func _process(delta):
	if Input.is_action_just_pressed("delsavedata"):
		DelSaveCount += 1
		if DelSaveCount > 2:
			Globals.SaveData(666)
			$Delsfx.play()

func _on_texture_button_pressed():
	Globals.SavedPos = Globals.load_game("user://dinomemories.save","SavedPos",Globals.SavedPos)
	if Globals.SavedPos[0] is not Vector2:
		Globals.SavedPos[0] = str_to_var(Globals.SavedPos[0])
	Globals.Items = Globals.load_game("user://dinomemories.save","Items",Globals.Items)
	Globals.BossKilled = Globals.load_game("user://dinomemories.save","BossKilled",Globals.BossKilled)
	Globals.EffectActive = Globals.load_game("user://dinomemories.save","EffectActive",Globals.EffectActive)
	Globals.SaveTime = Globals.load_game("user://dinomemories.save","SaveTime",Globals.SaveTime)
	Globals.SpecialItem = Globals.load_game("user://dinomemories.save","SpecialItem",Globals.SpecialItem)
	Globals.NumDeaths = Globals.load_game("user://dinomemories.save","NumDeaths",Globals.NumDeaths)
	
	get_tree().change_scene_to_file(Globals.AreaScenes[Globals.SavedPos[1]])


func _on_texture_button_2_pressed():
	$SettingsMenu.visible = true
