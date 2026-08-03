extends Node2D

@onready var PNode = get_tree().get_first_node_in_group("player")

@onready var MusicColl = [null,$Music,$Music2,$Music3]

var CPlaying : int = 0

var PrevRoom : Vector2 

var ActivarHands = false

func _ready():
	$Stuff/EndStuff/AnimationPlayer.play("RESET")
	if STEvents.EventArray[STEvents.Enums.FakeHallEndCutscene] == true:
		DestroyCMaster()
		$Stuff/EndFHall/CPUParticles2D.emitting = true
	Globals.CArea = 4
	CheckMusic()
	UpdateMusic()

var RotSpeed = 0.2

func _process(delta):
	if PNode.CRoomPos == Vector2(0,0) and !STEvents.EventArray[STEvents.Enums.FTTheConstruct]:
		STEvents.EventArray[STEvents.Enums.FTTheConstruct] = true
		SignalBus.ShowAreaIntro.emit("The construct")
	if PrevRoom != PNode.CRoomPos:
		CheckMusic()
		if MusicColl[CPlaying]:
			if !MusicColl[CPlaying].playing:
				UpdateMusic()
		else:
			UpdateMusic()
	PrevRoom = PNode.CRoomPos
	
	if ActivarHands:
		$Stuff/EndStuff/HandAudio.volume_db += delta*8.0
		$Stuff/EndStuff/HandAudio.volume_db = min($Stuff/EndStuff/HandAudio.volume_db,5.0)
		$Stuff/EndStuff/Hands.rotation += (PI*RotSpeed)*delta
		RotSpeed += delta*1.7
		$Stuff/EndStuff/Hands.global_position = PNode.global_position
	
	#if FountainActivar and Input.is_action_just_pressed("Confirm"):
		#Globals.LoadScene("res://Scenes/village/epilogue_3.tscn")

func UpdateMusic():
	for i in MusicColl.size():
		if MusicColl[i]:
			MusicColl[i].playing = i == CPlaying

func CheckMusic():
	if PNode.CRoomPos.y == 0 and PNode.CRoomPos.x < 7:
		CPlaying = 1
		return
	if PNode.CRoomPos.x >= 7 and PNode.CRoomPos.x < 11:
		CPlaying = 2
		return
	if PNode.CRoomPos.x >= 11:
		CPlaying = 3
		return
	if CPlaying:
		CPlaying = 0
		return


func _on_cutscene_trigger_body_entered(body):
	if body.is_in_group("player"):
		
		#if Globals.SpecialItem:
			#$Stuff/EndStuff/AnimationPlayer.play("EndAnimAlt")
		#else:
			#$Stuff/EndStuff/AnimationPlayer.play("EndAnim")
			$Stuff/EndStuff/AnimationPlayer.play("EndAnimNew")

func _on_animation_player_animation_finished(anim_name):
	#if anim_name == "EndAnim":
		#ActivarHands = true
		#$Stuff/EndStuff/Hands.visible = true
		#$Stuff/EndStuff/HandTimer.start()
		#$Stuff/EndStuff/HandAudio.play()
	#if anim_name == "EndAnimAl":
	if anim_name == "EndAnimNew":
		DestroyCMaster()
		STEvents.EventArray[STEvents.Enums.FakeHallEndCutscene] = true
		$Stuff/EndFHall/CPUParticles2D.emitting = true

func DestroyCMaster():
	$Stuff/EndStuff/CutsceneTrigger.queue_free()
	$Stuff/EndStuff/Blockade.queue_free()
	$Stuff/EndStuff/Blockade2.queue_free()
	$Stuff/EndStuff/RottingMaster.queue_free()
	$Stuff/EndStuff/AnimatedSprite2D.queue_free()
	$Stuff/EndStuff/Henryk.queue_free()
	$Stuff/EndStuff/LabelHen.queue_free()

func RESET():
	$Stuff/EndStuff/AnimationPlayer.play("RESET")


func _on_hand_timer_timeout():
	Globals.LoadScene("res://Scenes/epilogue_2.tscn")
	Globals.PosSetTravel = Vector2(470,-388)


var FountainActivar = false

func _on_fountain_l_body_entered(body):
	if body.is_in_group("player"):
		$Stuff/EndFHall/FountainL/Labels.visible = true
		#SignalBus.emit_signal("SetHudMessage","Press space to end",0)
		#FountainActivar = true
		

func _on_fountain_l_body_exited(body):
	if body.is_in_group("player"):
		$Stuff/EndFHall/FountainL/Labels.visible = false
		#SignalBus.emit_signal("SetHudMessage","",0)
		#FountainActivar = false
