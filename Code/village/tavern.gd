extends Node2D

enum {EARLY_SHOTGUN,LATER_SHOTGUN}

func _ready():
	SignalBus.GetInDial.connect(GetInDial)
	
	$Stuff/Secret/OnenTalk/Label.text = GetOnenText()

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
		if Globals.Items[Globals.Weapon][Globals.Shotgun]:
			$Stuff/TavernStuff/Mayor/EventNode.Text = AltTexts[EARLY_SHOTGUN]

var AltTexts = [
	[["Oh, nice you got the shotgun","Well then, you can kill The Horse, it resides in the tower to the west","Wait... was it locked or something?","Hmm.. well, I think if you explore, you may find something to open it"],
	["Well, nothing else to say except good luck"]
	]
]


func GetOnenText():
	var FText = "Hello othenson\n"
	if Globals.NumTimesBeatGame>0:
		if Globals.NumTimesBeatGame==1:
			FText += "It seems that you have achieved an endpoint,\nstill it didn't amount to much, did it?\nYou are still here after all"
		if Globals.NumTimesBeatGame>1:
			FText += "You have repeated your steps over and over,\nyou've struggled your way through this place {0} times".format([Globals.NumTimesBeatGame])
	else:
		FText += "It seems that you found your way here,\neven before achieving any endpoint\n\nWell, come back when you achieve something,\nI will not offer anything beneficial,\nbut instead I can reflect back on your struggles"
		return FText
	
	
	if Globals.Endings[Globals.End.EndingPeace]:
		FText += "\n\nYou were far in the east, in the peaceful meadows\nyou were close to something but at the same time, there was nothing there"
	if Globals.Endings[Globals.End.EndingPain]:
		FText += "\n\nYou have even gathered ascension,\ngotten rid of the rotten sludge coursing through you,\nbut still... that amounted to nothing"
	if Globals.Endings[Globals.End.EndingTravel]:
		FText += "\n\nHmm.. that key that you possess\nA sign of progress, something that remained\nMaybe all this struggle will lead you somewhere interesting after all \nWell maybe not right now... but in the future"
	
	return FText

func _on_onen_talk_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$Stuff/Secret/OnenTalk/Label.visible = true

func _on_onen_talk_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$Stuff/Secret/OnenTalk/Label.visible = false
