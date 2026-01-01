extends Node2D

enum {EARLY_SHOTGUN,LATER_SHOTGUN}

func _ready():
	SignalBus.GetInDial.connect(GetInDial)

var SpokenTo := 0

func GetInDial(State,Type,Early):
	if Type.is_in_group("mayor"):
		if State:
			$Stuff/TavernStuff/Mayor/MayorSprite.play("Talking")
		else:
			$Stuff/TavernStuff/Mayor/MayorSprite.play("default")
			if !Early:
				SpokenTo += 1
				if SpokenTo >= 2:
					STEvents.EventArray[STEvents.MayorSpokenToWithHint] = true
				SpokenTo = min(2,SpokenTo)

var AltTexts = {
	EARLY_SHOTGUN:[
		
	],
	LATER_SHOTGUN:[
		
	]
}
