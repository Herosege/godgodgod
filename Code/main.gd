extends Node2D

var Pos

@onready var PNode = get_tree().get_first_node_in_group("player")

func _ready():
	Globals.CArea = 0 
	for i in G1.size():
		Pos = G1[i].position.y
	

@onready var G1 = get_tree().get_nodes_in_group("group1")

var T = 0.0

var CPlaying 
@onready var MusicColl = [null,$Music,$Music2]  

func _process(delta):
	T+=delta/2
	if PrevRoom != PNode.CRoomPos:
		CPlaying = UpdateMusic()
		
		for i in MusicColl.size():
			if MusicColl[i]:
				MusicColl[i].playing = i == CPlaying
	PrevRoom = PNode.CRoomPos

var PrevRoom : Vector2

func UpdateMusic():
	if PNode.CRoomPos.x == 3 || PNode.CRoomPos == Vector2(6,1):
		return 0
	if PNode.CRoomPos.x < 3 and !$Music.playing:
		return 1
	if PNode.CRoomPos.x > 3 and PNode.CRoomPos.y >= 0 and !$Music2.playing:
		return 2
