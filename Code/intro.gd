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
	print(Globals.NumTimesBeatGame)
	if Globals.NumTimesBeatGame:
		$Label4.visible = true
		$Label4.text = "You beat the game " + str(Globals.NumTimesBeatGame) + " times!"
	
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
	
	
	
	get_tree().change_scene_to_file(Globals.AreaScenes[Globals.SavedPos[1]])


func _on_texture_button_2_pressed():
	$SettingsMenu.visible = true
