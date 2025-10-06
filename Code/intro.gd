extends Control

func _ready():
	
	$AudioStreamPlayer.pitch_scale = 0.3
	$AudioStreamPlayer.play()
	Globals.stoptime = true
	
	AudioServer.set_bus_volume_db(0,(Globals.MVol/4)-15)
	AudioServer.set_bus_mute(0,!Globals.MVol)
	AudioServer.set_bus_volume_db(1,(Globals.SEVol/4)-15)
	AudioServer.set_bus_mute(1,!Globals.SEVol)
	
	Globals.Endings = Globals.load_game(Globals.PATH_TO_PERMASAVE,"Endings",Globals.Endings)
	Globals.NumTimesBeatGame = Globals.load_game(Globals.PATH_TO_PERMASAVE,"BGame",Globals.NumTimesBeatGame)
	Globals.BestTime = Globals.load_game(Globals.PATH_TO_PERMASAVE,"BestTime",Globals.BestTime)
	Globals.LDeaths = Globals.load_game(Globals.PATH_TO_PERMASAVE,"LDeaths",Globals.LDeaths)
	#Globals.TimerOn = Globa
	
	Globals.NumDeaths = Globals.load_game(Globals.PATH_TO_GAMESAVE,"NumDeaths",Globals.NumDeaths)
	
	STEvents.EventArray = Globals.load_game(Globals.PATH_TO_GAMESAVE,"EventArray",STEvents.EventArray)
	
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
		$Says/Label.text = "I can beat the game with\nonly " + str(int(Globals.LDeaths)) + " deaths!!!" if Globals.LDeaths > 0 else "I am the one true god!"
	
	$Trophies/StdEnd.visible = Globals.Endings[Globals.End.EndingStd]
	$Trophies/PainEnd.visible = Globals.Endings[Globals.End.EndingPain]
	$Trophies/PeaceEnd2.emitting = Globals.Endings[Globals.End.EndingPeace]

var DelSaveCount = 0

func _process(delta):
	if Input.is_action_just_pressed("delsavedata"):
		DelSaveCount += 1
		if DelSaveCount > 2:
			Globals.SaveData(666)
			$Delsfx.play()

func _on_texture_button_pressed():
	if !Globals.load_game(Globals.PATH_TO_GAMESAVE,"SavedPos",false):
		get_tree().change_scene_to_file("res://Scenes/epic_intro.tscn")
		return
	Globals.SavedPos = Globals.load_game(Globals.PATH_TO_GAMESAVE,"SavedPos",Globals.SavedPos)
	if Globals.SavedPos[0] is not Vector2:
		Globals.SavedPos[0] = str_to_var(Globals.SavedPos[0])
	Globals.Items = Globals.load_game(Globals.PATH_TO_GAMESAVE,"Items",Globals.Items)
	Globals.BossKilled = Globals.load_game(Globals.PATH_TO_GAMESAVE,"BossKilled",Globals.BossKilled)
	Globals.EffectActive = Globals.load_game(Globals.PATH_TO_GAMESAVE,"EffectActive",Globals.EffectActive)
	Globals.SaveTime = Globals.load_game(Globals.PATH_TO_GAMESAVE,"SaveTime",Globals.SaveTime)
	Globals.SpecialItem = Globals.load_game(Globals.PATH_TO_GAMESAVE,"SpecialItem",Globals.SpecialItem)
	Globals.NumDeaths = Globals.load_game(Globals.PATH_TO_GAMESAVE,"NumDeaths",Globals.NumDeaths)
	Globals.RotCKilled = Globals.load_game(Globals.PATH_TO_GAMESAVE,"RotCKilled",Globals.RotCKilled)
	
	get_tree().change_scene_to_file(Globals.AreaScenes[Globals.SavedPos[1]])
	Globals.stoptime = false


func _on_texture_button_2_pressed():
	$SettingsMenu.visible = true

var Tooltips = [
	"Are you really sure that what you are doing is a correct way forward?",
	"Try to stop smiling sometimes",
	"If you struggle, remember to give up sometimes",
	"Pain is necessary to improve"
]
