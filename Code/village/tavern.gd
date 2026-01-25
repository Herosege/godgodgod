extends Node2D

enum {EARLY_SHOTGUN,LATER_SHOTGUN}

func _ready():
	SignalBus.GetInDial.connect(GetInDial)
	
	$Stuff/Secret/OnenTalk/Labels.visible = false
	$Stuff/Secret/OnenTalk/Labels/Label3.visible = false
	if Globals.NumTimesBeatGame>0:
		$Stuff/Secret/OnenTalk/Labels/Label.text = "You have repeated your steps over and over\nYou know that there is no path forward"
	else:
		$Stuff/Secret/OnenTalk/Labels/Label.text = "Do you think, all the effort will amount to anything?\nI will tell you right now, there is no path forward"
	
	if Globals.Endings[Globals.End.EndingTravel]:
		$Stuff/Secret/OnenTalk/Labels/Label3.visible = true
		if !Globals.Endings[Globals.End.EndingPain]:
			$Stuff/Secret/OnenTalk/Labels/Label2.visible = false
	else:
		if !Globals.Endings[Globals.End.EndingPain]:
			$Stuff/Secret/OnenTalk/Labels/Label2.text = "All that is really there, is an infinite repetition\nAlthough I may help you find a way out of all this\nCome back when you achieve something significant"
	

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


func _on_onen_talk_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$Stuff/Secret/OnenTalk/Labels.visible = true

func _on_onen_talk_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$Stuff/Secret/OnenTalk/Labels.visible = false
