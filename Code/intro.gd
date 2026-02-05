extends Control

func _ready():
	
	$AudioStreamPlayer.pitch_scale = 0.3
	$AudioStreamPlayer.play()
	Globals.stoptime = true
	
	Globals.LoadKeybinds()
	
	AudioServer.set_bus_volume_db(2,(Globals.MVol/4)-15)
	AudioServer.set_bus_mute(2,!Globals.MVol)
	AudioServer.set_bus_volume_db(1,(Globals.SEVol/4)-15)
	AudioServer.set_bus_mute(1,!Globals.SEVol)
	
	var TempEndings = Globals.load_game(Globals.PATH_TO_PERMASAVE,"Endings",Globals.Endings)
	for i in TempEndings.size():
		Globals.Endings[i] = TempEndings[i] 
	Globals.NumTimesBeatGame = Globals.load_game(Globals.PATH_TO_PERMASAVE,"BGame",Globals.NumTimesBeatGame)
	Globals.BestTime = Globals.load_game(Globals.PATH_TO_PERMASAVE,"BestTime",Globals.BestTime)
	Globals.LDeaths = Globals.load_game(Globals.PATH_TO_PERMASAVE,"LDeaths",Globals.LDeaths)
	var ExStateRecs = Globals.load_game(Globals.PATH_TO_PERMASAVE,"ExStatesRecords",Globals.ExStatesRecords)
	for i in ExStateRecs.size():
		Globals.ExStatesRecords[i] = ExStateRecs[i]
	#Globals.TimerOn = Globa
	var States = $StatesMenu/Bg/MarginContainer/VBoxContainer.get_children()
	for i in Globals.ExStatesRecords.size():
		var RLabel = States[i].get_node("Record")
		if RLabel and Globals.ExStatesRecords[i][Globals.StateRec.NumTimesBeat] > 0:
			var Times = Globals.sec_to_time(Globals.ExStatesRecords[i][Globals.StateRec.BTime])
			var StrSec = str(Times[0]) if floor(Times[0]/10.0) > 0 else "0"+str(Times[0])
			var StrMin = str(Times[1]) if floor(Times[1]/10.0) > 0 else "0"+str(Times[1])
			var Ovtime =  str(Times[2]) + ":" + StrMin + ":" + StrSec
			
			var LDeaths = str(int(Globals.ExStatesRecords[i][Globals.StateRec.BDeath]))
			
			var NumTBeat = str(int(Globals.ExStatesRecords[i][Globals.StateRec.NumTimesBeat]))
			
			RLabel.text = "Times beaten: {0} - Least deaths: {1} - Best time: {2}".format([NumTBeat,LDeaths,Ovtime])
	
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
		$Says/Label.text = "I can beat the game with\nonly " + str(int(Globals.LDeaths)) + " deaths!!!" if Globals.LDeaths > 0 else "I am the one true GOD!"
	
	$StatesOfExistence.visible = Globals.Endings[Globals.End.EndingTravel]
	
	$Trophies/StdEnd.visible = Globals.Endings[Globals.End.EndingStd]
	$Trophies/PainEnd.visible = Globals.Endings[Globals.End.EndingPain]
	$Trophies/PeaceEnd2.emitting = Globals.Endings[Globals.End.EndingPeace]
	$Trophies/TravelingEnd.visible = Globals.Endings[Globals.End.EndingTravel]

var DelSaveCount = 0

func _process(delta):
	if Input.is_action_just_pressed("delsavedata"):
		DelSaveCount += 1
		if DelSaveCount > 2:
			Globals.SaveData(667)
			$Delsfx.play()
			DelSaveCount = 0

func _on_texture_button_pressed():
	if Globals.TravelingBack:
		get_tree().change_scene_to_file("res://Scenes/traveling_intro.tscn")
		return
	if !Globals.load_game(Globals.PATH_TO_GAMESAVE,"SavedPos",false):
		get_tree().change_scene_to_file("res://Scenes/epic_intro.tscn")
		return
	
	
	Globals.NumDeaths = Globals.load_game(Globals.PATH_TO_GAMESAVE,"NumDeaths",Globals.NumDeaths)
	STEvents.EventArray = Globals.load_game(Globals.PATH_TO_GAMESAVE,"EventArray",STEvents.EventArray)
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
	Globals.TravelingBack = Globals.load_game(Globals.PATH_TO_GAMESAVE,"TravelingBack",Globals.TravelingBack)
	
	get_tree().change_scene_to_file(Globals.AreaScenes[Globals.SavedPos[1]])
	Globals.stoptime = false


func _on_texture_button_2_pressed():
	$SettingsMenu.visible = true

var Tooltips = [
	"Are you really sure that what you are doing is a correct way forward?",
	"Try to stop smiling sometimes",
	"If you struggle, remember to give up",
	"Pain is necessary to improve"
]


func _on_states_of_existence_pressed():
	$StatesMenu.visible = true
