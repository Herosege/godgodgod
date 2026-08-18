extends Node2D

@onready var PNode = get_tree().get_first_node_in_group("player")

@onready var AnimPos = $AnimationPlayer_pos
@onready var Anim = $HorsePivot/Horse/Sprite/AnimationPlayer
@onready var AnimInd = $Indicators/IndicationAnims

@onready var Line = $VisualStuff/Line

@onready var Horse = $HorsePivot/Horse
@onready var HorseCenter = $HorsePivot/Horse/Sprite/Body
@onready var HorsePivot = $HorsePivot

@onready var HBar = $BossHealth

@onready var AttTimer = $AttackTimer
@onready var SubAttTimer = $SubAttackTimer

@onready var PassBlock = $BlockPassage

const BASE_HEALTH := 27.0

enum Att {AttackWalk,AttackMid,AttackSideCover,AttackCrossInit,AttackCross}
#,AttackCross
var CAtt := -1 

var AttackCounter := 0

var Health := BASE_HEALTH : 
	set(value):
		Health = value
		HBar.value = HBar.max_value * (Health/BASE_HEALTH)

var Activar := false
var Alive := true

const POS_OFFSET := Vector2(640,480) * Vector2(1,-7)

var FristSideCoverAtt := true

### ATTACK WALK

const ATTWALK_TIME := 2.3
const ATTWALK_SUBTIME := 0.3


const ATTWALK_VELOCITY := 25.0
const ATTWALK_ACCEL := 70.0

const MUSIC_INIT_PITCH := 1.0
const MUSIC_END_PITCH := 2.0

### ATTACK MIDDLE

const ATTMID_TIME := 2.7
const ATTMID_SUBTIME_INIT := 1.1
const ATTMID_SUBTIME := 0.3

const ATTMID_BALL_INIT_LAUNCH := 10
const ATTMID_BALL_INIT_LAUNCH_ANGLE_RAD := PI/24
const ATTMID_BALL_ACCEL := 1600.0
const ATTMID_BALL_VELOCITY := 730.0

const ATTMID_ATPLAYER_ACCEL := 103.0
const ATTMID_ATPLAYER_VELOCITY := 35.0

### ATTACK SIDE COVER

@onready var IndicatorCover := $Indicators/AttackIndicatorCover

var AttCoverVariant := 0.0
var AttCoverPosFrom := Vector2.ZERO

const ATTSCOVER_TIME := 1.1
const ATTSCOVER_SUBTIME := 0.8

const ATTSCONVER_BALL_VELOCITY := 600.0
const ATTSCONVER_BALL_ACCEL := 500.0

const ATTSCOVER_BALL_INIT_LAUNCH := 8
const ATTSCOVER_BALL_DISTANCE : float = 320/ATTSCOVER_BALL_INIT_LAUNCH

### ATT CROSS

@onready var IndicatorCross := $Indicators/AttackIndicatorCross

const ATTCROSS_INIT_TIME := 3.5

const ATTCROSS_TIME := 2.3
const ATTCROSS_SUBTIME := 0.6

const ATTCROSS_BALL_VELOCITY := 500.0
const ATTCROSS_BALL_ACCEL := 500.0

const ATTCROSS_BALL_STEP := 30.0

const ATTCROSS_BALL_EACHSIDE := 6

func _ready():
	AttTimer.timeout.connect(on_AttTimer_timeout)
	
	await get_tree().create_timer(0.1).timeout
	HBar.visible = false
	RESET()
	if Globals.BossKilled[Globals.Horse] == true:
		queue_free()

func _process(delta):
	if Activar and Alive:
		ProcessAttacks(delta)
		
		if Line.visible == true:
			Line.width = lerp(Line.width,0.1,0.1)
			if Line.width < 2:
				Line.visible = false
		
		if Input.is_action_just_pressed("debug") and OS.is_debug_build():
			#AttMidIntoCross()
			get_dmg(BASE_HEALTH*0.67)


func ProcessAttacks(delta):
	match CAtt:
		Att.AttackWalk:
			if SubAttTimer.is_stopped() and AttackCounter < 5:
				var Towards = (PNode.global_position - HorseCenter.global_position).normalized()
				var TowAccel = (PNode.global_position - HorseCenter.global_position).normalized()
				Shoot(HorseCenter.global_position,Towards,ATTWALK_VELOCITY,1.8,TowAccel,ATTWALK_ACCEL)
				SubAttTimer.start(ATTWALK_SUBTIME)
				AttackCounter+=1
		Att.AttackMid:
			pass
		#Att.AttackCross:
			#pass

func get_dmg(dmg):
	if Activar and Alive:
		$GetDmg.stop()
		$GetDmg.play("dmg get")
		$BossMusic.pitch_scale = 1+((1-Health/BASE_HEALTH)/3)
		Health -= dmg
		if Health <= BASE_HEALTH/3.0 and not(CAtt == Att.AttackCross or CAtt == Att.AttackCrossInit):
			AttMidIntoCross()
		if Health <= 0.0:
			KILLHORSE()

func _on_boss_start_body_entered(body):
	if body.is_in_group("player"):
		$BossMusic.play()
		CAtt = -1
		PassBlock.global_position = Vector2(0,112)
		HBar.visible = true
		Activar = true
		AnimPos.play("start")
		Anim.play("start_battle")
		$BossStart/CollisionShape2D.set_deferred("disabled",true)
		AttTimer.start(0.6)
		#CAtt = randi_range(0,Att.size()-1)
		


#Run across the field from left to right, can stop at some moment and shoot bullets
func AttackWalking():
	#SubAttTimer.start(AttackTimers[Att.AttackWalk][1])
	AttTimer.start(ATTWALK_TIME)
	Anim.play("walking")
	AnimPos.play("walk")

func AttackWalkingStop():
	SubAttTimer.start(ATTWALK_SUBTIME)
	AttTimer.start(ATTWALK_TIME)
	Anim.play("walking")
	AnimPos.play("walk")

func AttackMiddle():
	SubAttTimer.start(ATTMID_SUBTIME_INIT)
	AttTimer.start(ATTMID_TIME)
	AnimInd.play("Flash")
	Anim.play("mid_att")
	AnimPos.play("mid_attack")

func AttackSideCover():
	SubAttTimer.start(ATTSCOVER_SUBTIME)
	AttTimer.start(ATTSCOVER_TIME)
	Anim.play("RESET")
	
	AnimPos.play("RESET")
	
	AttCoverVariant = (PNode.global_position.x - 640) > 304.0
	
	#AttCoverPosFrom = Vector2(0.0,186.0) if AttCoverVariant > 0.5 else Vector2(304.0,186.0)
	AttCoverPosFrom = Vector2(-16.0,186.0) if not AttCoverVariant else Vector2(320.0,186.0)
	IndicatorCover.position = AttCoverPosFrom
	
	AnimInd.play("FlashCover")

func AttMidIntoCross():
	CAtt = Att.AttackCrossInit
	SubAttTimer.start(ATTMID_SUBTIME_INIT)
	AttTimer.start(ATTCROSS_INIT_TIME)
	AnimInd.play("Flash")
	Anim.play("cross_start")
	AnimPos.play("mid_attack_into_cross")
	
	for i in $Bullets.get_children():
		i.Velocity = Vector2.ZERO
		i.Acceleration = Vector2.ZERO
		i.AccelSpeed = 0.0

func AttackCross():
	var PPos : float = PNode.global_position.x 
	Horse.position.x = 0.0
	HorsePivot.position.x = PPos + 28
	IndicatorCross.position.x = PPos - 640
	AnimInd.play("FlashCross")
	Anim.play("RESET")
	Anim.play("cross_att")
	AnimPos.play("att_cross")
	SubAttTimer.start(ATTCROSS_SUBTIME)
	AttTimer.start(ATTCROSS_TIME)

var BulletScene = load("res://Scenes/temple/bullet_ball.tscn")

func Shoot(From:Vector2,At:Vector2,speed:float,lifetime:=4.0,AccelDir:=Vector2.ZERO,AccelSpeed:=0.0):
	var BulInst = BulletScene.instantiate()
	BulInst.Speed = speed
	BulInst.global_position = From
	BulInst.Towards = At
	BulInst.DeleteTime = lifetime
	BulInst.AccelSpeed = AccelSpeed
	if AccelDir != Vector2.ZERO:
		BulInst.AccelDir = AccelDir
	$Bullets.call_deferred("add_child",BulInst)

func on_AttTimer_timeout():
	if CAtt == -1:
		CAtt = [Att.AttackWalk,Att.AttackMid].pick_random()
		ActivateAttack()
		return
	
	if CAtt == Att.AttackCross or CAtt == Att.AttackCrossInit:
		CAtt = Att.AttackCross
	
	else:
		CAtt = PickRandomAttack()
	
	ActivateAttack()
	

func PickRandomAttack():
	var OptionArray = []
	var Option := -1
	
	match CAtt:
		Att.AttackWalk:
			OptionArray = [Att.AttackMid,Att.AttackSideCover]
		Att.AttackMid:
			OptionArray = [Att.AttackWalk,Att.AttackSideCover]
		Att.AttackSideCover:
			OptionArray = [Att.AttackWalk,Att.AttackMid]
	
	Option = OptionArray.pick_random()
	
	return Option

func ActivateAttack():
	AttackCounter = 0
	var OldPos = HorseCenter.global_position
	if Activar and Alive:
		match CAtt:
			Att.AttackWalk:
				SubAttTimer.start((ATTWALK_SUBTIME*randf()*0.75)+(ATTWALK_SUBTIME/2.0))
				AttackWalking()
			Att.AttackMid:
				AttackMiddle()
			Att.AttackSideCover:
				AttackSideCover()
			Att.AttackCross:
				AttackCross()
	await get_tree().physics_frame
	await get_tree().physics_frame
	LineUpdate(OldPos,HorseCenter.global_position)

func LineUpdate(Pos1:Vector2,Pos2:Vector2):
	Line.set_point_position(0,Pos1)
	Line.set_point_position(1,Pos2)
	Line.width = 50.0
	Line.visible = true

func RESET():
	if Alive:
		$BossMusic.pitch_scale = MUSIC_INIT_PITCH
		$BossMusic.stop()
		HorsePivot.position = Vector2.ZERO
		FristSideCoverAtt = true
		PassBlock.global_position = Vector2.ZERO
		Line.visible = false
		CAtt = -1
		Health = BASE_HEALTH
		Activar = false
		AnimPos.play("RESET")
		Anim.play("RESET")
		AttTimer.stop()
		SubAttTimer.stop()
		for i in $Bullets.get_children():
			i.queue_free()
		await get_tree().physics_frame
		if not Globals.BossKilled[Globals.Horse] == true:
			$BossStart/CollisionShape2D.set_deferred("disabled",false)


func _on_sub_attack_timer_timeout():
	match CAtt:
		Att.AttackWalk:
			pass
		Att.AttackMid:
			AttMidTimeout()
		Att.AttackSideCover:
			AttSideCoverTimout()
		Att.AttackCrossInit:
			AttCrossInitTimeout()
		Att.AttackCross:
			AttCrossTimeout()

func AttMidTimeout():
	if AttackCounter==0:
		AttackCounter+=1
		var CalcAngle = ATTMID_BALL_INIT_LAUNCH_ANGLE_RAD*randf_range(0.8,1.2)
		
		for i in range(0,ATTMID_BALL_INIT_LAUNCH):
			
			var CalcVal = i - floor(ATTMID_BALL_INIT_LAUNCH/2.0)
			var LaunchAt = Vector2(sin(CalcAngle)*CalcVal,-1).normalized()
			var TowAccel = Vector2(0,1)
			Shoot(Horse.global_position,LaunchAt,ATTMID_BALL_VELOCITY,4.0,TowAccel,ATTMID_BALL_ACCEL)
		
		CalcAngle = ATTMID_BALL_INIT_LAUNCH_ANGLE_RAD*randf_range(0.7,1.1)
		var MID_LAUNCH2 = ATTMID_BALL_INIT_LAUNCH+2
		
		for i in range(0,MID_LAUNCH2):
			var From = Horse.global_position
			var TowAccel = Vector2(0,1)
			var CalcVal = i - floor(MID_LAUNCH2/2.0)
			var LaunchAt = Vector2(sin(CalcAngle)*CalcVal,-1)
			Shoot(From,LaunchAt,ATTMID_BALL_VELOCITY,4.0,TowAccel,ATTMID_BALL_ACCEL/1.3)
		
		CalcAngle = ATTMID_BALL_INIT_LAUNCH_ANGLE_RAD*0.25
		MID_LAUNCH2 = ATTMID_BALL_INIT_LAUNCH
		
		
		for i in range(0,MID_LAUNCH2):
			var From = Horse.global_position
			var TowAccel = Vector2(0,1)
			var CalcVal = i - floor(MID_LAUNCH2/2.0)
			var LaunchAt = Vector2(sin(PI/150)+(sin(CalcAngle)*CalcVal),-1)
			Shoot(From,LaunchAt,ATTMID_BALL_VELOCITY*1.2,4.0,TowAccel,ATTMID_BALL_ACCEL/1.3)
		
		SubAttTimer.start(ATTMID_SUBTIME)
		return
	
	#if AttackCounter >= 1 and AttackCounter < 4:
		#var From = HorseCenter.global_position
		#var TowAccel = (PNode.global_position - HorseCenter.global_position).normalized()
		#var LaunchAt = (PNode.global_position - HorseCenter.global_position).normalized()
		#Shoot(From,LaunchAt,ATTMID_ATPLAYER_VELOCITY,1.8,TowAccel,ATTMID_ATPLAYER_ACCEL)
		#SubAttTimer.start(ATTMID_SUBTIME*AttackCounter)
		#AttackCounter+=1

func AttSideCoverTimout():
	for i in ATTSCOVER_BALL_INIT_LAUNCH+1:
		var From := POS_OFFSET+AttCoverPosFrom
		From.x += ATTSCOVER_BALL_DISTANCE*i
		Shoot(From,Vector2.UP,ATTSCONVER_BALL_VELOCITY,3.0,Vector2(0,1),ATTSCONVER_BALL_ACCEL)

func AttCrossInitTimeout():
	var CalcAngle = ATTMID_BALL_INIT_LAUNCH_ANGLE_RAD
	
	for j in range(0,4):
		for i in range(0,ATTMID_BALL_INIT_LAUNCH+2):
			CalcAngle = ATTMID_BALL_INIT_LAUNCH_ANGLE_RAD
			var CalcVal = i - floor(ATTMID_BALL_INIT_LAUNCH/2.0)
			var LaunchAt = Vector2(sin(CalcAngle)*CalcVal+((j-2)/20.0),-1).normalized()
			var TowAccel = Vector2(0,1)
			Shoot(Horse.global_position+Vector2(0,-200),LaunchAt,ATTMID_BALL_VELOCITY/(1+(float(j)/20.0)),2.5,TowAccel,ATTMID_BALL_ACCEL/(1+(float(j)/2.7)))

func AttCrossTimeout():
	var ShootFrom = HorseCenter.global_position
	var Rand = (randf() * 0.5)+0.5
	for j in ATTCROSS_BALL_EACHSIDE+1:
		for i in 2:
			var SignOfI = -1 if i==0 else 1
			Shoot(ShootFrom+Vector2(SignOfI*j*ATTCROSS_BALL_STEP*Rand,100.0),Vector2.UP,ATTCROSS_BALL_VELOCITY*(1+(float(j)/10.0)),2.6,Vector2.DOWN,ATTCROSS_BALL_ACCEL)
		await get_tree().create_timer(0.1).timeout
		if !Activar:
			return

func KILLHORSE():
	AttTimer.stop()
	SubAttTimer.stop()
	$Crosstimer.stop()
	Alive = false
	Activar = false
	Globals.BossKilled[Globals.Horse] = true
	$BossMusic.stop()
	Anim.play("RESET")
	AnimPos.play("RESET")
	$HorseDeath.play("HorseDeath")
	HorsePivot.position = Vector2.ZERO
	for i in $Bullets.get_children():
		i.queue_free()
	
	await get_tree().physics_frame
	Anim.play("die")

func AfterHorseKill():
	queue_free()


func _on_horse_death_animation_finished(anim_name):
	if anim_name == "HorseDeath":
		AfterHorseKill()
