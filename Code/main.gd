extends Node2D

var Pos

@onready var PNode = get_tree().get_first_node_in_group("player")
@onready var G1 = get_tree().get_nodes_in_group("group1")
@onready var MusicColl = [null,$Music,$Music2,$Music3,$Music4,$Music5,$Music6]  

var T = 0.0

var CPlaying = 0

var EndGame = false

func _ready():
	Globals.stoptime = false
	PNode.global_position = Globals.SavedPos[0]
	if !Globals.SpecialItem:
		$Npcs/henryk2.visible = true
	$ImpStuff/Label.visible = !Globals.EnemiesKilled
	SignalBus.EnemyKilled.connect(OnEnemyKilled)
	Globals.CArea = 0 
	for i in G1.size():
		Pos = G1[i].position.y
	if Globals.SpecialItem:
		$ImpStuff/BridgeGate.queue_free()
		$Npcs/idk.queue_free()
	CheckMusic()
	UpdateMusic()
	

func _process(delta):
	T+=delta/2
	if PrevRoom != PNode.CRoomPos:
		CheckMusic()
		if MusicColl[CPlaying]:
			if !MusicColl[CPlaying].playing:
				UpdateMusic()
		else:
			UpdateMusic()
		
		if randf() < 0.02:
			RandomEvent()
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
	if PNode.CRoomPos.x >= 13 and PNode.CRoomPos.y == 0 and endmove != 3 and !EndGame:
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
		
		EndScene(Globals.SpecialItem)

var endmove = 0
@onready var wifetexture = $EndStuff/TextureRect

func EndScene(hasSpecial):
	if (hasSpecial):
		await get_tree().create_timer(3.0).timeout
		wifetexture.visible = true
		wifetexture.global_position = PNode.global_position + Vector2(-181.0,-155.5)
		endmove = 1
		$EndStuff/AudioStreamPlayer.play()
		
		await get_tree().create_timer(4.0).timeout
		endmove = 2
		wifetexture.global_position = Vector2(8644.0-181.0,240.0-155.5)
		
		await get_tree().create_timer(2.0).timeout
		EndGame = true
		endmove = 0
		$EndStuff/AudioStreamPlayer.stop()
		$Music5.stop()
		$EndStuff/TextureRect.visible = false
		$CursePillar.visible = false
		$EndStuff/TileMapLayer2.queue_free()
		$EndStuff/TileMapLayer3.position = Vector2.ZERO
		$EndStuff/TextureRect2.visible = true
		$EndStuff/TextureRectG.visible = true
	else:
		await get_tree().create_timer(1.0).timeout
		$Npcs/henryk2/AnimatedSprite2D.play("freakingout")
		$Npcs/npc/AudioStreamPlayer.play()
		$Npcs/henryk2/Label.text = "ALRIGHT LETS MURDER THIS\nDISGUSTING SHITPILE"
		
		await get_tree().create_timer(3.1).timeout
		$Npcs/npc/AudioStreamPlayer.volume_db = -1
		$Npcs/henryk2/Label.text = "OK, I THINK IT WAS THIS SPELL"
		
		await get_tree().create_timer(3.0).timeout
		$Npcs/npc/AudioStreamPlayer.volume_db = 4
		$Npcs/henryk2/Label.text = "JKKJLLLJLLLKJJKLLKJKKKLKJJKLLKJJKLLLKJKKKLKJJKLL"
		
		await get_tree().create_timer(2.7).timeout
		get_tree().call_deferred("change_scene_to_file","res://Scenes/epilogue_2.tscn")
		

func RandomEvent():
	var EventType = randi() % 2
	match EventType:
		0:
			$CanvasLayer/ColorRect.color = Color.RED
			$FunnyStuff/BGTIMER.start()
		1:
			$FunnyStuff/CanvasLayer/img1.visible = true
			$FunnyStuff/CanvasLayer/img1.position = Vector2((640-128)*randf(),(480-128)*randf())
			$FunnyStuff/BGTIMER.start()

func _on_bgtimer_timeout():
	$CanvasLayer/ColorRect.color = Color.AQUA
	$FunnyStuff/CanvasLayer/img1.visible = false
