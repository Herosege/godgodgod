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
		if PNode.CRoomPos.x >= 7 and PNode.CRoomPos.x < 13 and PNode.CRoomPos.y != 0 and !$Music3.playing:
			CPlaying = 3
			UpdateMusic()
		if PNode.CRoomPos.x >= 9 and PNode.CRoomPos.x < 13 and PNode.CRoomPos.y == 0 and !$Music4.playing:
			CPlaying = 4
			UpdateMusic()
		if PNode.CRoomPos.x >= 13 and PNode.CRoomPos.y == 0 and !$Music5.playing and endmove != 3:
			CPlaying = 5
			UpdateMusic()
	PrevRoom = PNode.CRoomPos
	if endmove:
		match endmove:
			1:
				wifetexture.global_position = wifetexture.global_position.move_toward(Vector2(8644.0-181.0,240.0-155.5),1.4)
			2:
				wifetexture.global_position.y = (240.0-155.5) - (wifetexture.global_position.y - 200.0)
		
var PrevRoom : Vector2

func UpdateMusic():
	for i in MusicColl.size():
			if MusicColl[i]:
				MusicColl[i].playing = i == CPlaying

func OnEnemyKilled(type):
	$ImpStuff/Label.visible = false

#the cool ending

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		$CursePillar/Area2D.queue_free()
		$dadoor.position = Vector2(8304,96)
		$EndStuff/EndTimer.start()

var endmove = 0
@onready var wifetexture = $EndStuff/TextureRect

func _on_end_timer_timeout():
	wifetexture.visible = true
	wifetexture.global_position = PNode.global_position + Vector2(-181.0,-155.5)
	endmove = 1
	$EndStuff/EndTimer2.start()
	$EndStuff/AudioStreamPlayer.play()

func _on_end_timer_2_timeout():
	endmove = 2
	wifetexture.global_position = Vector2(8644.0-181.0,240.0-155.5)
	$EndStuff/FinalTimer.start()

func _on_final_timer_timeout():
	endmove = 0
	$EndStuff/AudioStreamPlayer.stop()
	$Music5.stop()
	$EndStuff/TextureRect.visible = false
	$CursePillar.visible = false
	$EndStuff/TileMapLayer2.queue_free()
	$EndStuff/TileMapLayer3.position = Vector2.ZERO
	$EndStuff/TextureRect2.visible = true
	$EndStuff/TextureRectG.visible = true
