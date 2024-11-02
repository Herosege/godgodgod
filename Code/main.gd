extends Node2D

var Pos

@onready var PNode = get_tree().get_first_node_in_group("player")
@onready var G1 = get_tree().get_nodes_in_group("group1")
@onready var MusicColl = [null,$Music,$Music2,$Music3]  

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
		if PNode.CRoomPos.x > 3 and PNode.CRoomPos.y >= 0 and !$Music2.playing:
			CPlaying = 2
			UpdateMusic()
		if PNode.CRoomPos.x >= 7 and !$Music3.playing:
			CPlaying = 3
			UpdateMusic()
	PrevRoom = PNode.CRoomPos

var PrevRoom : Vector2

func UpdateMusic():
	for i in MusicColl.size():
			if MusicColl[i]:
				MusicColl[i].playing = i == CPlaying

func OnEnemyKilled(type):
	$ImpStuff/Label.visible = false
