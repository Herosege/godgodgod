extends Node

enum Enums {MayorSpokenToWithHint,HorseHaluShown,FakeHallEndCutscene,LPassageOpen,RPassageOpen}

var EventArray = []

var OneTimeJammers = []

var RombsGotten = []

func _enter_tree():
	for i in Enums:
		EventArray.append(false)
