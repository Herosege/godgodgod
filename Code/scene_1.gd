extends Node

@onready var PNode = get_tree().get_first_node_in_group("player")

func _enter_tree():
	Globals.CArea = 1

func _ready():
	$Stuff/Npcs/idk/AudioStreamPlayer.pitch_scale = 2.5
	$Music1.pitch_scale = 0.25
	$Music1.volume_db = -13.5
	$CameraControl.UpdateCam()
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


func _process(delta):
	if $Music1.pitch_scale != 0.25:
		$Music1.pitch_scale = 0.25


var GateOpened = false

func _on_EffectChange(value,type):
	if value == true and type == Globals.Beer and !GateOpened:
		GateOpened = true
		$Gate2.call_deferred("queue_free")
		pass
#stuff

func _on_idk_body_entered(body):
	if body.is_in_group("player"):
		SignalBus.emit_signal("SetHudMessage","???",0)

func _on_idk_body_exited(body):
	if body.is_in_group("player"):
		SignalBus.emit_signal("SetHudMessage","",0)


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


func _on_wife_body_entered(body):
	if body.is_in_group("player"):
		Globals.SpecialItem = true
		SignalBus.emit_signal("GetItem","wife")
		SignalBus.emit_signal("Save",0)
		$Secrets/Wife.queue_free()


func _on_curse_guy_body_entered(body):
	if body.is_in_group("player"):
		$Secrets/CurseGuy/text.visible = true

func _on_curse_guy_body_exited(body):
	if body.is_in_group("player"):
		$Secrets/CurseGuy/text.visible = false
