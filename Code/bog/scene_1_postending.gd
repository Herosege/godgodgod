extends Node

var Balls = []
var BArr = []

@onready var BaseCont = $Stuff/Balls
@onready var PNode = get_tree().get_first_node_in_group("player")

const RotSpeed = 10.0

var PrevRoom

func _ready():
	PrevRoom = PNode.CRoomPos
	Globals.CArea = 7
	for i in BaseCont.get_children():
		if i is Area2D:
			BArr.append(i)
			var TApp = GenBalls(i,BArr)
			Balls.append(TApp.duplicate())
			BArr.resize(0)

func _process(delta):
	if PrevRoom != PNode.CRoomPos:
		MusicStuff()
	PrevRoom = PNode.CRoomPos

func MusicStuff():
	if PNode.CRoomPos.x <= -3:
		$Music1.playing = false
		return
	if $Music1.playing == false:
		$Music1.playing = true 


func GenBalls(BCont,BArr):
	for i in BCont.get_children():
		if i is Area2D:
			BArr.append(i)
			GenBalls(i,BArr)
			return BArr

func _physics_process(delta):
	for i in Balls.size():
		for j in Balls[i].size():
			Balls[i][j].rotation += delta * RotSpeed / ((j+1)*2)

func RESET():
	for i in Balls.size():
		for j in Balls[i].size():
			Balls[i][j].rotation = 0.0


func _on_idk_body_entered(body):
	if body.is_in_group("player"):
		SignalBus.emit_signal("SetHudMessage","???",0)

func _on_idk_body_exited(body):
	if body.is_in_group("player"):
		SignalBus.emit_signal("SetHudMessage","",0)


func _on_area_2d_area_entered(area):
	if area.is_in_group("damage"):
		$Stuff/Gate.queue_free()


func _on_key_area_body_entered(body):
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://Scenes/Bog/epilogue_traveling.tscn")


func _on_special_item_get_body_entered(body):
	if body.is_in_group("player"):
		Globals.SpecialItem = true
		SignalBus.emit_signal("GetItem","wife")
		$Stuff/BossRotting/Special.queue_free()
