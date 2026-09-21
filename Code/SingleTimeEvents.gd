extends Node

enum Enums {MayorSpokenToWithHint,HorseHaluShown,FakeHallEndCutscene,LPassageOpen,RPassageOpen,
	FTFlowerFields,FTCurseWorld,FTCollapsedBridge,FTTheGreatTower,FTTheVillage,FTTheConstruct,FTTheTempleOfHania,FTRottingFields,
	FTTheGreatRotting,FTFirmamentWaters,FTHouseInstance,
	SmallHorseKilled
	}


var EventArray = []

var OneTimeJammers = []

var RombsGotten = []

#Speedrun times - 10 minutes

enum ACHIEVEMENT {
	BEAT_THE_GAME_1,
	BEAT_THE_GAME_2,
	BEAT_THE_GAME_3,
	LEAST_DEATH_1,
	LEAST_DEATH_2,
	LEAST_DEATH_3,
	SPEEDRUN_1,
	SPEEDRUN_2,
	SPEEDRUN_3
	}

var Achievements = [
	load("res://Resources/Achievements/beat_game_1.tres"),
	load("res://Resources/Achievements/beat_game_2.tres"),
	load("res://Resources/Achievements/beat_game_3.tres"),
	load("res://Resources/Achievements/least_death_1.tres"),
	load("res://Resources/Achievements/least_death_2.tres"),
	load("res://Resources/Achievements/least_death_3.tres"),
	load("res://Resources/Achievements/speedrun_time_1.tres"),
	load("res://Resources/Achievements/speedrun_time_2.tres"),
	load("res://Resources/Achievements/speedrun_time_3.tres")
]

var Achiev_complete = [] : 
	get():
		if Achiev_complete.size() == 0:
			for i in Achievements:
				Achiev_complete.append(i.Achieved)
			return Achiev_complete
		
		for i in Achievements.size():
			Achiev_complete[i] = Achievements[i].Achieved
		return Achiev_complete


func _enter_tree():
	for i in Enums:
		EventArray.append(false)
	
	for i in Achievements.size():
		Achievements[i].ID = i

func _ready():
	pass
	#for i in Achievements:
		#if randf()>0.0:
			#i.Achieved = true
