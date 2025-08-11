extends Node

@onready var PNode = get_tree().get_first_node_in_group("player")

func _enter_tree():
	Globals.CArea = 1

func _ready():
	$Stuff/Npcs/idk/AudioStreamPlayer.pitch_scale = 2.5
	$Music1.pitch_scale = 0.25
	$Music1.volume_db = -13.5
	$CameraControl.UpdateCam()
	PNode.global_position = Globals.SavedPos[0]
	Globals.stoptime = false
	if Globals.BossKilled[Globals.VoidSpaghetti] == true:
		SignalBus.emit_signal("BossDead",Globals.VoidSpaghetti)
		$BossTrigger.call_deferred("queue_free")
	SignalBus.TriggerBoss.connect(_on_Trigger_Boss)
	SignalBus.ScreenShaderChange.connect(_on_EffectChange)
	$BossWall/CollisionShape2D.set_deferred("disabled",true)
	$BossWall.visible = false
	$TextureRect5.visible = false

func _on_Trigger_Boss(type):
	if type == 1:
		$BossTrigger/CollisionShape2D.set_deferred("disabled",true)
		$BossWall/CollisionShape2D.set_deferred("disabled",false)
		$BossWall.visible = true
		$MusicBoss.play()

var CDir = 1

func _process(delta):
	if $Music1.pitch_scale != 0.25:
		$Music1.pitch_scale = 0.25
	if randf() > 0.3:
		$Stuff/Npcs/idk/goodlabel.position.y += CDir 
		CDir = -CDir

var GateOpened = false

func _on_EffectChange(value,type):
	if value == true and type == Globals.Beer and !GateOpened:
		GateOpened = true
		$Gate2.call_deferred("queue_free")
		pass
#stuff

func _on_idk_body_entered(body):
	$Stuff/Npcs/idk/AudioStreamPlayer.play()
	$Stuff/Npcs/idk/goodlabel.global_position = PNode.position
	CDir *= 200

func _on_idk_body_exited(body):
	$Stuff/Npcs/idk/AudioStreamPlayer.stop()
	$Stuff/Npcs/idk/goodlabel.position = Vector2(-272,-240)
	CDir /= 200


func _on_boss_trigger_body_entered(body):
	if body.is_in_group("player"):
		SignalBus.emit_signal("TriggerBoss",1)

func RESET():
	if Globals.BossKilled[Globals.VoidSpaghetti] == false:
		$BossTrigger/CollisionShape2D.set_deferred("disabled",false)
		$BossWall/CollisionShape2D.set_deferred("disabled",true)
		$BossWall.visible = false
	$Stuff/MovingStuff/AnimationPlayer.play("RESET")
	$Stuff/MovingStuff/AnimationPlayer.play("plat")
	$MusicBoss.stop()
