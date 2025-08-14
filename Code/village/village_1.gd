extends Node2D

@onready var PNode = get_tree().get_first_node_in_group("player")

@onready var MusicColl = [null,$Music,$Music2]

var CPlaying : int

func _ready():
	Globals.CArea = 2
	CheckMusic()
	UpdateMusic()

var PrevRoom : Vector2

func _process(delta):
	if PrevRoom != PNode.CRoomPos:
		CheckMusic()
		if MusicColl[CPlaying]:
			if !MusicColl[CPlaying].playing:
				UpdateMusic()
		else:
			UpdateMusic()
	PrevRoom = PNode.CRoomPos

func _on_main_place_gate_body_entered(body):
	if body.is_in_group("player"):
		Globals.LoadScene("res://Scenes/main.tscn")
		#get_tree().call_deferred("change_scene_to_file","res://Scenes/main.tscn")
		Globals.PosSetTravel = Vector2(9532,-70)

func CheckMusic():
	if PNode.CRoomPos.y <= -2 and PNode.CRoomPos.y >= -11:
		CPlaying = 1
		return
	if PNode.CRoomPos.y < -11:
		CPlaying = 2
		return
	if CPlaying:
		CPlaying = 0
		return

func UpdateMusic():
	for i in MusicColl.size():
		if MusicColl[i]:
			MusicColl[i].playing = i == CPlaying

func RESET():
	$Stuff/MovingStuff/AnimationPlayer.play("RESET")
	$Stuff/MovingStuff/AnimationPlayer.play("moving")
	$Stuff/MovingStuff/AnimationPlayer2.play("RESET")
	$Stuff/MovingStuff/AnimationPlayer2.play("moving")
