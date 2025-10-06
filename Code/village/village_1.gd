extends Node2D

@onready var PNode = get_tree().get_first_node_in_group("player")

@onready var MusicColl = [null,$Music,$Music2,$Music3,$Music4]

@onready var OTimer = $Houses/Village/Buildings/HorseTemple/OpenTimer

var CPlaying : int

func _ready():
	OTimer.connect("timeout",OnOpenTimerTimeout)
	if STEvents.EventArray[STEvents.HorseHaluShown] == false and STEvents.EventArray[STEvents.MayorSpokenToWithHint] == true:
		$Houses/Village/Stuff/HorseHalucination.visible = true
	Globals.CArea = 2
	CheckMusic()
	UpdateMusic()
	SignalBus.GetInDial.connect(GetInDial)

var PrevRoom : Vector2

var HandSpawned = false

const CLOUD_SCREEN_AMOUNT_TRAVEL = 3

func _process(delta):
	if STEvents.EventArray[STEvents.HorseHaluShown] == false:
		if PNode.position.x < 640 and PNode.position.x > 0 and PNode.position.y < -5800:
			STEvents.EventArray[STEvents.HorseHaluShown] = true
			$Houses/Village/Stuff/HorseHalucination.visible = false
	
	if PNode.position.x < 0 and PNode.position.y > -50:
		Globals.LoadScene("res://Scenes/main.tscn")
		Globals.PosSetTravel = Vector2(9600+PNode.position.x,-450)
	
	if PNode.position.x > 5400 and PNode.position.y < 500 and PNode.position.y > -500 and PNode.CRoomPos.x < 13 and !HandSpawned and STEvents.EventArray[STEvents.FakeHallEndCutscene] == false:
		HandSpawned = true
		HandACTIVAR()
	
	if PNode.CRoomPos.x >= 13:
		$Bgs/Clouds.visible = false
	else:
		$Bgs/Clouds.visible = true
	
	if PrevRoom != PNode.CRoomPos:
		$Bgs/Clouds.position.x = floor(PNode.CRoomPos.x/CLOUD_SCREEN_AMOUNT_TRAVEL)*640*CLOUD_SCREEN_AMOUNT_TRAVEL
		CheckMusic()
		if MusicColl[CPlaying]:
			if !MusicColl[CPlaying].playing:
				UpdateMusic()
		else:
			UpdateMusic()
	PrevRoom = PNode.CRoomPos
	
	if ExAwaitInp and Input.is_action_just_pressed("Confirm"):
		Globals.LoadScene("res://Scenes/village/epilogue_1.tscn")

func _on_main_place_gate_body_entered(body):
	if body.is_in_group("player"):
		Globals.LoadScene("res://Scenes/main.tscn")
		#get_tree().call_deferred("change_scene_to_file","res://Scenes/main.tscn")
		Globals.PosSetTravel = Vector2(9532,-70)

func CheckMusic():
	if PNode.CRoomPos.y <= -2 and PNode.CRoomPos.y >= -11 and PNode.CRoomPos.x < 13:
		CPlaying = 1
		return
	if PNode.CRoomPos.y < -11 and PNode.CRoomPos.x < 13:
		CPlaying = 2
		return
	if PNode.CRoomPos.y >= 4 and PNode.CRoomPos.x < 13:
		CPlaying = 3
		return
	if PNode.CRoomPos.x >= 13:
		CPlaying = 4
		return
	if CPlaying:
		CPlaying = 0
		return

func UpdateMusic():
	for i in MusicColl.size():
		if MusicColl[i]:
			MusicColl[i].playing = i == CPlaying

#SHOTGUN SECRET
func _on_out_body_entered(body):
	if body.is_in_group("player"):
		$SecretStuff/ShotgunPlace/FakeLayer0.modulate.a = 1.0

func _on_in_body_entered(body):
	if body.is_in_group("player"):
		$SecretStuff/ShotgunPlace/FakeLayer0.modulate.a = 0.2

func RESET():
	HandSpawned = false
	$SecretStuff/ShotgunPlace/FakeLayer0.modulate.a = 1.0
	$Stuff/MovingStuff/AnimationPlayer.play("RESET")
	$Stuff/MovingStuff/AnimationPlayer.play("moving")
	$Stuff/MovingStuff/AnimationPlayer2.play("RESET")
	$Stuff/MovingStuff/AnimationPlayer2.play("moving")

func HandACTIVAR():
	var HInst = load("res://Scenes/village/hand.tscn").instantiate()
	add_child(HInst)

func GetInDial(State,Type,Early):
	if Type == "fisher":
		if State:
			$Houses/Village/Fisher/FisherAnim.play("default")
		else:
			$Houses/Village/Fisher/FisherAnim.stop()

func _on_onen_coll_body_entered(body):
	if body.is_in_group("player"):
		$Houses/Village/OnenBTower/Label.visible = true
		if OTimer.is_stopped():
			OTimer.start()

func _on_onen_coll_body_exited(body):
	if body.is_in_group("player"):
		$Houses/Village/OnenBTower/Label.visible = false


func _on_fh_pass_body_entered(body):
	if body.is_in_group("player"):
		Globals.LoadScene("res://Scenes/village/fake_hall.tscn")
		Globals.PosSetTravel = Vector2(530,-440)

var HTempOpen = preload("res://Assets/village/HorseTemple_open.png")

func OnOpenTimerTimeout():
	$Houses/Village/Buildings/HorseTemple/HTemple.texture = HTempOpen
	$Houses/Village/Buildings/HorseTemple/HTempleTele.position = Vector2(-3000,-6350)

func _on_h_temple_tele_body_entered(body):
	Globals.LoadScene("res://Scenes/village/abba.tscn")

var ExAwaitInp = false

func _on_ex_npc_body_entered(body):
	if body.is_in_group("player"):
		$Extra/Npc/Label.visible = true
		SignalBus.emit_signal("SetHudMessage","Press space to accept",0)
		ExAwaitInp = true

func _on_ex_npc_body_exited(body):
	if body.is_in_group("player"):
		$Extra/Npc/Label.visible = false
		SignalBus.emit_signal("SetHudMessage","",0)
		ExAwaitInp = false
