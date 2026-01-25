extends Node2D

const InitHealth := 32.0

var Health = InitHealth

var Killed = false

var skipped = true

var Phase = 0 : 
	set(val):
		Phase = val
		match Phase:
			1:
				$MusicBoss2.volume_db = 0.0
				Hearts = 2
				SpawnHeart(Vector2(-2500,150))
				SpawnHeart(Vector2(-1980,150))
				$LayerPhase2.position.y = 0
				Timer1Time = 1.4
				Timer2Time = 4.5
				Timer2DistTime = 0.4
				if Timers.get_node("Timer3").is_stopped():
					Timers.get_node("Timer3").start(Timer3Time)
			2:
				Timer2Time = 1.05
				Timer2DistTime = 0.2

var Fighting = false

@onready var HBar = $BossHealth
@onready var Timers = $Cooldowns
@onready var PNode = get_tree().get_first_node_in_group("player")

var BHeartScene = load("res://Scenes/Bog/boss_heart.tscn")

const BTimer1Time := 0.4
const BTimer2Time := 3.5
const BTimer2DistTime := 0.2
const BTimer3Time := 4.0

var Timer1Time := BTimer1Time
var Timer2Time := BTimer2Time
var Timer2DistTime := BTimer2DistTime
var Timer3Time := BTimer3Time

var Hearts = 0

func _ready():
	SignalBus.BossHeartDamage.connect(OnBossHeartDamage)

func _on_greatestrotting_body_entered(body):
	if body.is_in_group("player") and !Fighting and Health > 0:
		$MusicBoss.play()
		$MusicBoss2.volume_db = -200.0
		$MusicBoss2.play()
		$LayerBossGate.position.y = 0
		Attack1()
		$BossSprite.sprite_frames.set_animation_speed("default",5.0)
		Hearts = 2
		SpawnHeart(Vector2(-2500,280))
		SpawnHeart(Vector2(-1980,280))
		Fighting = true
		HBar.visible = true

func _process(delta):
	if Input.is_action_just_pressed("debug"):
		get_dmg(20.0)
	
	if !skipped and Input.is_action_just_pressed("Confirm") and Killed:
		$Death/AnimationPlayer.play("Die",-1,1000.0)
		$Death/Skip.visible = false
		skipped = true
	
	if Fighting:
		match Phase:
			0:
				if Timers.get_node("Timer1").is_stopped():
					Att1Stages += 1
					Att1Stages = (Att1Stages % (BAttStages/2)) + BAttStages
					Timers.get_node("Timer1").start(Timer1Time)
					Attack1()
				if Timers.get_node("Timer2").is_stopped():
					Timers.get_node("Timer2").start(Timer2Time)
					Attack2()
			1:
				if Timers.get_node("Timer1").is_stopped():
					Att1Stages += 1
					Att1Stages = (Att1Stages % (BAttStages/2)) + BAttStages
					Timers.get_node("Timer1").start(Timer1Time)
					Attack1()
				if Timers.get_node("Timer2").is_stopped():
					Timers.get_node("Timer2").start(Timer2Time)
					Attack2()
				if Timers.get_node("Timer3").is_stopped():
					Timers.get_node("Timer3").start(Timer3Time)
					Attack3()
			2:
				if Timers.get_node("Timer2").is_stopped():
					Timers.get_node("Timer2").start(Timer2Time)
					Attack2()
				if Timers.get_node("Timer3").is_stopped():
					Timers.get_node("Timer3").start(Timer3Time)
					Attack3()

const BBAttStages = 16
var BAttStages = BBAttStages
var Att1Stages = BAttStages

func Attack1():
	for i in Att1Stages:
		Shoot($BossSprite.global_position,$BossSprite.global_position+Vector2(cos((PI/Att1Stages*2)*i),sin((PI/Att1Stages*2)*i)),120)

var Att2Stages := 4
const Att2Distances := 80

func Attack2():
	for i in Att2Stages:
		for j in i:
			Shoot($BossSprite.global_position,PNode.global_position+((Vector2(j,j)*Att2Distances)-Vector2((Att2Distances/2)*j,(Att2Distances/2)*j))+PNode.velocity/5,300)
		Timers.get_node("Timer2Dist").start(Timer2DistTime)
		await Timers.get_node("Timer2Dist").timeout

@onready var CRect = $Phase2/ColorRect

func Attack3():
	var Pos = PNode.global_position 
	CRect.global_position.x = Pos.x-CRect.size.x/2
	$Phase2/BallH/Ball3.global_position.x = Pos.x
	$Phase2/AnimationPlayer.play("FlashInd")


var BulletScene = load("res://Scenes/bullet.tscn")

func SpawnHeart(At):
	var BHInst = BHeartScene.instantiate()
	BHInst.global_position = At
	$BossHearts.call_deferred("add_child",BHInst)

func Shoot(From,At,speed):
	var BulInst = BulletScene.instantiate()
	BulInst.Speed = speed
	BulInst.global_position = From
	BulInst.Towards = At
	$"../Bullets".call_deferred("add_child",BulInst)

func OnBossHeartDamage(Dmg):
	get_dmg(Dmg)
	Hearts -= 1
	if Hearts == 0:
		Phase += 1

func get_dmg(amt):
	if Fighting:
		Health -= amt
		HBar.value = (Health / InitHealth) * 100 
	if Health <= 0:
		Globals.SavedPos[0] = Vector2(-2000,420)
		Killed = true
		Fighting = false
		for i in Timers.get_children():
			i.stop()
		for i in $"../Bullets".get_children():
			i.queue_free()
		for i in $BossHearts.get_children():
			i.queue_free()
		HBar.visible = false
		$MusicBoss.stop()
		$MusicBoss2.stop()
		$Phase2/AnimationPlayer.play("RESET")
		$Death/AnimationPlayer.play("Die")
		if Globals.Endings[Globals.End.EndingTravel]:
			$Death/Skip.visible = true
		skipped = false

func RESET():
	if !Killed:
		BAttStages = BBAttStages
		$MusicBoss.stop()
		$MusicBoss2.stop()
		$Phase2/AnimationPlayer.play("RESET")
		$Death/AnimationPlayer.play("RESET")
		Timer1Time = BTimer1Time
		Timer2Time = BTimer2Time
		Timer2DistTime = BTimer2DistTime
		
		Att1Stages = BAttStages
		Phase = 0
		
		Health = InitHealth
		HBar.visible = false
		HBar.value = 100.0
		
		$LayerPhase2.position.y = -640
		$LayerBossGate.position.y = 1280
		$BossSprite.sprite_frames.set_animation_speed("default",10.0)
		
		for i in Timers.get_children():
			i.stop()
		for i in $"../Bullets".get_children():
			i.queue_free()
		for i in $BossHearts.get_children():
			i.queue_free()
		
		Fighting = false


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Die":
		$LayerBossGate2.queue_free()
		$Special/Sprite2D.position.y+=480
		await get_tree().create_timer(0.7).timeout
		$Special/SpecialItemGet.set_deferred("position",$Special/SpecialItemGet.position+Vector2(0,480))
