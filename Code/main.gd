extends Node2D

var Pos

@onready var PNode = get_tree().get_first_node_in_group("player")

func _ready():
	if PNode.CRoomPos == Vector2(0,0):
		$Music.playing = true
	$Music2.playing = false
	Globals.CArea = 0 
	for i in G1.size():
		Pos = G1[i].position.y
	

@onready var G1 = get_tree().get_nodes_in_group("group1")

var T = 0.0

func _process(delta):
	T+=delta/2
	UpdateMusic()
	PrevRoom = PNode.CRoomPos

var PrevRoom : Vector2

func UpdateMusic():
	if PrevRoom != PNode.CRoomPos:
		if PNode.CRoomPos.x == 3 || PNode.CRoomPos == Vector2(6,1):
			$Music.playing = false
			$Music2.playing = false
			return
		if PNode.CRoomPos.x < 3 and !$Music.playing:
			$Music.playing = true
			$Music2.playing = false
			return
		if PNode.CRoomPos.x > 3 and PNode.CRoomPos.y >= 0 and !$Music2.playing:
			$Music2.playing = true
			$Music.playing = false
			return
