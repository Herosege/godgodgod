extends Node2D

var Pos

@onready var PNode = get_tree().get_first_node_in_group("player")
@onready var G1 = get_tree().get_nodes_in_group("group1")
@onready var MusicColl = [null,$Music,$Music2,$Music3,$Music4,$Music5,$Music6]  

var T = 0.0

var CPlaying = 0

func _ready():
	if Globals.SpecialItem:
		$Npcs/henryk2.queue_free()
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
		CheckMusic()
		if MusicColl[CPlaying]:
			if !MusicColl[CPlaying].playing:
				UpdateMusic()
		else:
			UpdateMusic()
	PrevRoom = PNode.CRoomPos
	if endmove:
		match endmove:
			1:
				wifetexture.global_position = wifetexture.global_position.move_toward(Vector2(8644.0-181.0,240.0-155.5),1.4)
			2:
				wifetexture.global_position.y = (240.0-155.5) - (wifetexture.global_position.y - 200.0)
		
var PrevRoom : Vector2

func CheckMusic():
	if PNode.CRoomPos.x == 3 || PNode.CRoomPos == Vector2(6,1):
		CPlaying = 0
		return
	if PNode.CRoomPos.x < 3:
		CPlaying = 1
		return
	if PNode.CRoomPos.x > 3 and PNode.CRoomPos.y >= 0 and  PNode.CRoomPos.x < 6:
		CPlaying = 2
		return
	if PNode.CRoomPos.x >= 7 and PNode.CRoomPos.x < 10 and PNode.CRoomPos.y < 0:
		CPlaying = 3
		return
	if PNode.CRoomPos.x >= 9 and PNode.CRoomPos.x < 13 and PNode.CRoomPos.y == 0:
		CPlaying = 4
		return
	if PNode.CRoomPos.x >= 13 and PNode.CRoomPos.y == 0 and endmove != 3 and !Globals.EndGame:
		CPlaying = 5
		return
	if PNode.CRoomPos.x >= 7 and PNode.CRoomPos.x <= 8 and PNode.CRoomPos.y >= 1:
		CPlaying = 6
		return
	if CPlaying:
		CPlaying = 0
		return

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
		if Globals.SpecialItem:
			
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
	Globals.EndGame = true
	endmove = 0
	$EndStuff/AudioStreamPlayer.stop()
	$Music5.stop()
	$EndStuff/TextureRect.visible = false
	$CursePillar.visible = false
	$EndStuff/TileMapLayer2.queue_free()
	$EndStuff/TileMapLayer3.position = Vector2.ZERO
	$EndStuff/TextureRect2.visible = true
	$EndStuff/TextureRectG.visible = true
