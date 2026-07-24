extends Node2D

@onready var PNode = get_tree().get_first_node_in_group("player")

@onready var MusicColl = [null,$Music/Music1,$Music/Music2,$Music/Music3]

var CPlaying : int = 0

var PrevRoom : Vector2 

var PasssagesAmnt = 0

func _ready():
	Globals.CArea = 8
	
	SignalBus.GetInDial.connect(GetInDial)
	
	if STEvents.EventArray[STEvents.Enums.RPassageOpen]:
		PasssagesAmnt+=1
	if STEvents.EventArray[STEvents.Enums.LPassageOpen]:
		PasssagesAmnt+=1
	
	if STEvents.EventArray[STEvents.Enums.RPassageOpen] == true:
		$Stuff/Passages/PassageRight.queue_free()
	if STEvents.EventArray[STEvents.Enums.LPassageOpen] == true:
		$Stuff/Passages/PassageLeft.queue_free()
	
	UpdatePassages()
	CheckMusic()
	UpdateMusic()


func _process(delta):
	if PNode.CRoomPos == Vector2(0,-2) and !STEvents.EventArray[STEvents.Enums.FTTheTempleOfHania]:
		STEvents.EventArray[STEvents.Enums.FTTheTempleOfHania] = true
		SignalBus.ShowAreaIntro.emit("The temple of Hania")
	
	if PrevRoom != PNode.CRoomPos:
		CheckMusic()
		if MusicColl[CPlaying]:
			if !MusicColl[CPlaying].playing:
				UpdateMusic()
		else:
			UpdateMusic()
	PrevRoom = PNode.CRoomPos

func UpdateMusic():
	for i in MusicColl.size():
		if MusicColl[i]:
			MusicColl[i].playing = i == CPlaying

func CheckMusic():
	if (PNode.CRoomPos.y <=-3 and PNode.CRoomPos.x == 0) or (PNode.CRoomPos.y <=-7) and PNode.CRoomPos != Vector2(1,-8):
		CPlaying = 3
		return
	if (PNode.CRoomPos.y > -2 and PNode.CRoomPos.y < 2) or (PNode.CRoomPos.y <=-5 and PNode.CRoomPos.x >= 2) or (PNode.CRoomPos.x >= 4):
		CPlaying = 2
		return
	if PNode.CRoomPos.y <= -2 and PNode.CRoomPos.x < 4 and PNode.CRoomPos != Vector2(1,-8):
		CPlaying = 1
		return
	if CPlaying:
		CPlaying = 0
		return


func _on_passage_right_body_entered(body):
	if body.is_in_group("player"):
		SignalBus.SetHudMessage.emit("A part of the passage unveils",1)
		STEvents.EventArray[STEvents.Enums.RPassageOpen] = true
		PasssagesAmnt+=1
		UpdatePassages()
		$Stuff/Passages/PassageRight.queue_free()

func _on_passage_left_body_entered(body):
	if body.is_in_group("player"):
		SignalBus.SetHudMessage.emit("A part of the passage unveils",1)
		STEvents.EventArray[STEvents.Enums.LPassageOpen] = true
		PasssagesAmnt+=1
		UpdatePassages()
		$Stuff/Passages/PassageLeft.queue_free()


func UpdatePassages():
	if PasssagesAmnt >= 1:
		$Stuff/Passages/Pass1.visible = true
		$Stuff/Passages/Pass1.collision_enabled = true
	if PasssagesAmnt == 2:
		$Stuff/Passages/Pass2.visible = true
		$Stuff/Passages/Pass2.collision_enabled = true


func _on_to_curse_world_body_entered(body):
	if body.is_in_group("player"):
		Globals.LoadScene("res://Scenes/scene_1.tscn")
		Globals.PosSetTravel = Vector2(530,-440)

func GetInDial(State,Type,Early):
	if Type.is_in_group("Wex"):
		if State:
			$Stuff/Npc/Worshipper4/Sprite2D.play("default")
		else:
			$Stuff/Npc/Worshipper4/Sprite2D.stop()
