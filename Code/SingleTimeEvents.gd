extends Node

enum Enums {MayorSpokenToWithHint,HorseHaluShown,FakeHallEndCutscene,LPassageOpen,RPassageOpen,
	FTFlowerFields,FTCurseWorld,FTCollapsedBridge,FTTheGreatTower,FTTheVillage,FTTheConstruct,FTTheTempleOfHania,FTRottingFields,
	FTTheGreatRotting,FTFirmamentWaters,FTVoid,FTHouseInstance,
	SmallHorseKilled
	}


var EventArray = []

var OneTimeJammers = []


enum RombLoc {FF_Morela,FF_TreeUnder,FF_MidBridge,
	CW_SecretRight,
	IP_Tavern,
	TOH_Outside,TOH_Inside,TOH_CWEntrance,
	V_Start,
	H_FF_Wall,
	H_CW_Right}

### ROMB LOCATIONS 
#Main - Morela, tree, mid bridge - 3
#Curse - Secret right - 1
#Village - 0
#fake hall - 0
#Inside places - Tavern - 1
#Temple - Outside,Inside,FarFarRight - 3
#Void - Void start - 1
## Hard mode 
#Main - next to wall - 1
#Curse - full right - 1
### TOTAL - 11

const ROMBS_TOTAL_AMOUNT := 11

var RombsGotten = []

func GetRombScene(RombPath):
	print(RombPath)

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
	SPEEDRUN_3,
	ALL_ROMBS
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
	load("res://Resources/Achievements/speedrun_time_3.tres"),
	load("res://Resources/Achievements/all_rombs.tres")
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

func GetRombCAmnt()->int:
	var Amnt := 0
	for i in RombsGotten.size():
		if RombsGotten[i]:
			Amnt += 1
	return Amnt


func _enter_tree():
	for i in Enums:
		EventArray.append(false)
	
	for i in Achievements.size():
		Achievements[i].ID = i
	
	for i in RombLoc:
		RombsGotten.append(false)

func _ready():
	pass
	#for i in Achievements:
		#if randf()>0.0:
			#i.Achieved = true
