extends Node2D

@onready var PNode = get_tree().get_first_node_in_group("player")

@onready var MusicColl = [null,$Music,$Music2]

var CPlaying : int = 0

var PrevRoom : Vector2 

var ActivarHands = false

func _ready():
	$Stuff/EndStuff/AnimationPlayer.play("RESET")
	if STEvents.EventArray[STEvents.FakeHallEndCutscene]:
		DestroyCMaster()
	Globals.CArea = 4

var RotSpeed = 0.2

func _process(delta):
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

func UpdateMusic():
	for i in MusicColl.size():
		if MusicColl[i]:
			MusicColl[i].playing = i == CPlaying

func CheckMusic():
	if PNode.CRoomPos.y == 0 and PNode.CRoomPos.x < 7:
		CPlaying = 1
		return
	if PNode.CRoomPos.x >= 7:
		CPlaying = 2
		return


func _on_cutscene_trigger_body_entered(body):
	if body.is_in_group("player"):
		$Stuff/EndStuff/AnimationPlayer.play("EndAnim")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "EndAnim":
		DestroyCMaster()
		STEvents.EventArray[STEvents.FakeHallEndCutscene] = true
		ActivarHands = true
		$Stuff/EndStuff/Hands.visible = true
		$Stuff/EndStuff/HandTimer.start()
		$Stuff/EndStuff/HandAudio.play()

func DestroyCMaster():
	$Stuff/EndStuff/CutsceneTrigger.queue_free()
	$Stuff/EndStuff/Blockade.queue_free()

func RESET():
	$Stuff/EndStuff/AnimationPlayer.play("RESET")


func _on_hand_timer_timeout():
	Globals.LoadScene("res://Scenes/epilogue_2.tscn")
