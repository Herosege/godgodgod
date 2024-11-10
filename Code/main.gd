extends Node2D

var Pos

@onready var PNode = get_tree().get_first_node_in_group("player")
@onready var G1 = get_tree().get_nodes_in_group("group1")
@onready var MusicColl = [null,$Music,$Music2,$Music3,$Music4,$Music5]  

var T = 0.0

var CPlaying 

func _ready():
	$ImpStuff/Label.visible = !Globals.EnemiesKilled
	SignalBus.EnemyKilled.connect(OnEnemyKilled)
	Globals.CArea = 0 
	for i in G1.size():
		Pos = G1[i].position.y
	if Globals.SpecialItem:
		$ImpStuff/BridgeGate.queue_free()
		$Npcs/idk.queue_free()

func _process(delta):
	T+=delta/2
	if PrevRoom != PNode.CRoomPos:
		if PNode.CRoomPos.x == 3 || PNode.CRoomPos == Vector2(6,1):
			CPlaying = 0
			UpdateMusic()
		if PNode.CRoomPos.x < 3 and !$Music.playing:
			CPlaying = 1
			UpdateMusic()
		if PNode.CRoomPos.x > 3 and PNode.CRoomPos.y >= 0 and  PNode.CRoomPos.x < 7 and !$Music2.playing:
			CPlaying = 2
			UpdateMusic()
		if PNode.CRoomPos.x >= 7 and PNode.CRoomPos.y != 0 and !$Music3.playing:
			CPlaying = 3
			UpdateMusic()
		if PNode.CRoomPos.x >= 9 and PNode.CRoomPos.x < 13 and PNode.CRoomPos.y == 0 and !$Music4.playing:
			CPlaying = 4
			UpdateMusic()
		if PNode.CRoomPos.x >= 13 and PNode.CRoomPos.y == 0 and !$Music5.playing:
			CPlaying = 5
			UpdateMusic()
	PrevRoom = PNode.CRoomPos
	if endmove:
		$EndStuff/TextureRect.global_position = $EndStuff/TextureRect.global_position.move_toward(Vector2(8644.0-181.0,240.0-155.5),2.0)
var PrevRoom : Vector2

func UpdateMusic():
	for i in MusicColl.size():
			if MusicColl[i]:
				MusicColl[i].playing = i == CPlaying

func OnEnemyKilled(type):
	$ImpStuff/Label.visible = false


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		$CursePillar/Area2D.queue_free()
		$dadoor.position = Vector2(8304,96)
		$EndStuff/EndTimer.start()
		

var endmove = false

func _on_end_timer_timeout():
	$EndStuff/TextureRect.visible = true
	$EndStuff/TextureRect.global_position = PNode.global_position + Vector2(-181.0,-155.5)
	endmove = true
	$EndStuff/EndTimer2.start()


func _on_end_timer_2_timeout():
	$EndStuff/TextureRect.visible = false
	$CursePillar.visible = false
