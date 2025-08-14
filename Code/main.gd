extends Node2D

var Pos

@onready var PNode = get_tree().get_first_node_in_group("player")
@onready var G1 = get_tree().get_nodes_in_group("group1")
@onready var MusicColl = [null,$Music,$Music2,$Music3,$Music4,$Music5,$Music6]  

var T = 0.0

var CPlaying = 0

var EndGame = false

func _ready():
	$BloodParticles2.emitting = true
	$BloodParticles2.visible = false
	
	Globals.stoptime = false
	$ImpStuff/Label.visible = !Globals.EnemiesKilled
	SignalBus.EnemyKilled.connect(OnEnemyKilled)
	Globals.CArea = 0 
	for i in G1.size():
		Pos = G1[i].position.y
	if Globals.RotCKilled:
		$Npcs/henryk2.visible = false
		UnrotCurse()

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
		
		if randf() < 0.01:
			RandomEvent()
	PrevRoom = PNode.CRoomPos
		
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
	if PNode.CRoomPos.x >= 13 and PNode.CRoomPos.y == 0 and !Globals.RotCKilled:
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
		Globals.SavedPos[0] = Vector2(8400,320)
		Globals.SavedPos[1] = 0
		EndScene(Globals.SpecialItem)

func EndScene(hasSpecial):
	await get_tree().create_timer(1.0).timeout
	$Npcs/henryk2/AnimatedSprite2D.play("freakingout")
	$Npcs/npc/AudioStreamPlayer.play()
	$Npcs/henryk2/Label.text = "ALRIGHT LETS MURDER THIS\nDISGUSTING THING"
	
	await get_tree().create_timer(3.1).timeout
	$Npcs/npc/AudioStreamPlayer.volume_db = -1
	$Npcs/henryk2/Label.text = "OK, I THINK IT WAS THIS SPELL"
	
	await get_tree().create_timer(3.0).timeout
	$Npcs/npc/AudioStreamPlayer.volume_db = 4
	$Npcs/henryk2/Label.text = "COW 3000 DRINK ASBESTOR AGOLMATIC REDO FUN EXTEND 2001 FRIEND ULUBOMTEKA"
	
	
	await get_tree().create_timer(2.7).timeout
	Globals.RotCKilled = true
	
	UnrotCurse()
	await get_tree().create_timer(0.7).timeout
	$Npcs/henryk2/Label.text = "OH WOW... THIS ACTUALLY WORKED"
	await get_tree().create_timer(2.7).timeout
	$Npcs/henryk2/Label.text = "ALRIGHT, BYE SEE YOU SOON :)"
	await get_tree().create_timer(1.5).timeout
	$Npcs/henryk2.visible = false

func RandomEvent():
	var EventType = randf()
	
	if EventType > 0.6:
		$CanvasLayer/ColorRect.color = Color.RED
		$FunnyStuff/BGTIMER.start()
	if EventType < 0.5:
		$FunnyStuff/CanvasLayer/img1.visible = true
		$FunnyStuff/CanvasLayer/img1.position = Vector2((640-128)*randf(),(480-128)*randf())
		$FunnyStuff/BGTIMER.start()

func _on_bgtimer_timeout():
	$CanvasLayer/ColorRect.color = Color.AQUA
	$FunnyStuff/CanvasLayer/img1.visible = false


func _on_village_pass_body_entered(body):
	if body.is_in_group("player"):
		Globals.PosSetTravel = Vector2(60,400)
		Globals.LoadScene("res://Scenes/village_1.tscn")

func RESET():
	$Hazards/SpikesMoving/AnimationPlayer.play("RESET")
	$Hazards/SpikesMoving/AnimationPlayer.play("SpikesMove")
	if randf() < 0.01:
		RandomEvent()
	CheckMusic()

func UnrotCurse():
	$dadoor.position = Vector2(8304,96)
	$Npcs/henryk2/Label.text = ""
	$Npcs/henryk2/AnimatedSprite2D.stop()
	$Npcs/npc/AudioStreamPlayer.stop()
	$EndStuff/AudioStreamPlayer.stop()
	$Music5.stop()
	$EndStuff/TextureRect.visible = false
	$CursePillar.queue_free()
	$EndStuff/TileMapLayer2.queue_free()
	$EndStuff/TileMapLayer3.position = Vector2.ZERO
	$EndStuff/TextureRect2.visible = true
	$EndStuff/TextureRect3.visible = true
	$EndStuff/TextureRect4.visible = true
	$EndStuff/TextureRect5.visible = true
	$EndStuff/TextureRect6.visible = true
	$EndStuff/TextureRect7.visible = true
	$EndStuff/TextureRectG.visible = true
	for i in range(1,$Enemies.get_children().size()):
		$Enemies.get_child(i).queue_free()
	$Visual/stuff/Sprite2D.modulate = Color.BLACK
	$Visual/stuff/Sprite2D2.modulate = Color.BLACK
	$SpikeAreas/Area2D/CollisionShape2D6.set_deferred("position",Vector2(6166,0))
