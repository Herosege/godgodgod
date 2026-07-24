extends Node2D

@onready var PNode = get_tree().get_first_node_in_group("player")

@onready var AnimPos = $AnimationPlayer_pos
@onready var Anim = $HorsePivot/Horse/Sprite/AnimationPlayer
@onready var AnimInd = $Indicators/IndicationAnims

@onready var Line = $VisualStuff/Line

@onready var Horse = $HorsePivot/Horse
@onready var HorseCenter = $HorsePivot/Horse/Sprite/Body

@onready var HBar = $BossHealth

@onready var AttTimer = $AttackTimer
@onready var SubAttTimer = $SubAttackTimer

@onready var PassBlock = $BlockPassage

const BASE_HEALTH := 28.0

enum Att {AttackWalk,AttackMid,AttackSideCover}
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

### ATTACK WALK

const ATTWALK_TIME := 2.75
const ATTWALK_SUBTIME := 0.3


### ATTACK MIDDLE
const ATTMID_TIME := 3.0
const ATTMID_SUBTIME_INIT := 1.1
const ATTMID_SUBTIME := 0.3

const ATTMID_BALL_INIT_LAUNCH := 10
const ATTMID_BALL_INIT_LAUNCH_ANGLE_RAD := PI/24
const ATTMID_BALL_ACCEL := 1600.0
const ATTMID_BALL_VELOCITY := 730.0

const ATTMID_ATPLAYER_ACCEL := 103.0
const ATTMID_ATPLAYER_VELOCITY := 35.0

### ATTACK SIDE COVER

var AttCoverVariant := 0
var AttCoverPosFrom := Vector2.ZERO

const ATTSCOVER_TIME := 1.2
const ATTSCOVER_SUBTIME := 0.64

const ATTSCONVER_BALL_VELOCITY := 650
const ATTSCONVER_BALL_ACCEL := 500

const ATTSCOVER_BALL_INIT_LAUNCH := 8
const ATTSCOVER_BALL_DISTANCE : float = 320/ATTSCOVER_BALL_INIT_LAUNCH

func _ready():
	AttTimer.timeout.connect(on_AttTimer_timeout)
	
	await get_tree().create_timer(0.1).timeout
	HBar.visible = false
	RESET()

func _process(delta):
	if Activar and Alive:
		ProcessAttacks(delta)
		
		if Line.visible == true:
			Line.width = lerp(Line.width,0.1,0.1)
			if Line.width < 2:
				Line.visible = false


func ProcessAttacks(delta):
	match CAtt:
		Att.AttackWalk:
			if SubAttTimer.is_stopped() and AttackCounter < 5:
				var Towards = (PNode.global_position - HorseCenter.global_position).normalized()
				var TowAccel = (PNode.global_position - HorseCenter.global_position).normalized()
				Shoot(HorseCenter.global_position,Towards,25.0,3.0,TowAccel,3.5*25.0)
				SubAttTimer.start(ATTWALK_SUBTIME)
				AttackCounter+=1
		Att.AttackMid:
			pass
		#Att.AttackCross:
			#pass

func get_dmg(dmg):
	if Activar and Alive:
		Health -= dmg

func _on_boss_start_body_entered(body):
	if body.is_in_group("player"):
		PassBlock.global_position = Vector2(0,112)
		HBar.visible = true
		Activar = true
		AnimPos.play("start")
		Anim.play("start_battle")
		$BossStart/CollisionShape2D.set_deferred("disabled",true)
		await Anim.animation_finished
		#CAtt = randi_range(0,Att.size()-1)
		CAtt = [Att.AttackWalk,Att.AttackMid].pick_random()
		ActivateAttack()


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
	
	AttCoverVariant = randi_range(0,1)
	AttCoverPosFrom = Vector2(0.0,186.0) if AttCoverVariant == 0 else Vector2(304.0,186.0)
	$Indicators/AttackIndicatorCover.position = AttCoverPosFrom
	
	AnimInd.play("FlashCover")

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
	await get_tree().physics_frame
	await get_tree().physics_frame
	LineUpdate(OldPos,HorseCenter.global_position)

func LineUpdate(Pos1:Vector2,Pos2:Vector2):
	Line.set_point_position(0,Pos1)
	Line.set_point_position(1,Pos2)
	Line.width = 50.0
	Line.visible = true

func RESET():
	PassBlock.global_position = Vector2.ZERO
	Line.visible = false
	CAtt = -1
	$BossStart/CollisionShape2D.set_deferred("disabled",false)
	Health = BASE_HEALTH
	Activar = false
	AnimPos.play("RESET")
	Anim.play("RESET")
	AttTimer.stop()
	SubAttTimer.stop()
	for i in $Bullets.get_children():
		i.queue_free()


func _on_sub_attack_timer_timeout():
	match CAtt:
		Att.AttackWalk:
			pass
		Att.AttackMid:
			AttMidTimeout()
		Att.AttackSideCover:
			AttSideCoverTimout()

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
	print(POS_OFFSET+AttCoverPosFrom)
	for i in ATTSCOVER_BALL_INIT_LAUNCH:
		var From := POS_OFFSET+AttCoverPosFrom
		From.x += ATTSCOVER_BALL_DISTANCE*i
		Shoot(From,Vector2.UP,ATTSCONVER_BALL_VELOCITY,3.0,Vector2(0,1),ATTSCONVER_BALL_ACCEL)
