extends Node2D

@onready var PNode = get_tree().get_first_node_in_group("player")

func _ready():
	Globals.CArea = 2
	MusicStuff()
	

var PrevRoom : Vector2

func _process(delta):
	if PrevRoom != PNode.CRoomPos:
		MusicStuff()

func _on_main_place_gate_body_entered(body):
	if body.is_in_group("player"):
		get_tree().call_deferred("change_scene_to_file","res://Scenes/main.tscn")
		await get_tree().process_frame
		Globals.SavedPos[0] = Vector2(9532,-70)
		Globals.SavedPos[1] = 0

func MusicStuff():
	if $Music.playing == false and PNode.CRoomPos.y <= -2:
		$Music.playing = true
	if $Music.playing == true and !(PNode.CRoomPos.y <= -2):
		$Music.playing = false

func RESET():
	$Stuff/MovingStuff/AnimationPlayer.play("RESET")
	$Stuff/MovingStuff/AnimationPlayer.play("moving")
	$Stuff/MovingStuff/AnimationPlayer2.play("RESET")
	$Stuff/MovingStuff/AnimationPlayer2.play("moving")
