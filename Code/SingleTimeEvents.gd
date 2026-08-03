extends Node

enum Enums {MayorSpokenToWithHint,HorseHaluShown,FakeHallEndCutscene,LPassageOpen,RPassageOpen,
	FTFlowerFields,FTCurseWorld,FTCollapsedBridge,FTTheGreatTower,FTTheVillage,FTTheConstruct,FTTheTempleOfHania,FTRottingFields,
	FTTheGreatRotting,FTFirmamentWaters,FTHouseInstance,
	SmallHorseKilled
	}


var EventArray = []

var OneTimeJammers = []

var RombsGotten = []

func _enter_tree():
	for i in Enums:
		EventArray.append(false)
