extends Node2D

@export_enum("Axe","Shotgun") var Type

@onready var AnimationTimer = $AnimationTime
@onready var HitboxTimer = $HitboxTime
@onready var PNode = get_tree().get_first_node_in_group("player")

enum {Passive,Weapon}
enum {Axe,Shotgun}

var CurWeapon = Axe

enum {Dmg,Cd}

var Weapons = [
	[AXE_DMG,0.125],
	[SHOTGUN_DMG,1.75]
]

const TIME_FLOOR := 0.8

const AXE_DMG = 1.0
const SHOTGUN_DMG = 3.0

var AnimTime

var Jammed := false
var OneTimeAmmo := false

var OnFloor = false

var ShotgunBulletsScene = preload("res://Scenes/village/shotgun_bullets.tscn")

func _ready():
	AnimTime = $AnimatedSprite2D.sprite_frames.get_frame_count("default") / $AnimatedSprite2D.sprite_frames.get_animation_speed("default")
	AnimationTimer.wait_time = AnimTime
	$Area2D/CollisionPolygon2D.set_deferred("disabled",true)
	$AnimatedSprite2D.visible = false
	
	AnimationTimer.connect("timeout",AnimTimerTimeout)

func _process(delta):
	if !$Cooldown.is_stopped():
		SignalBus.emit_signal("ShotgunTimerHudUpdate",$Cooldown.time_left,$Cooldown.wait_time)
	if Input.is_action_just_pressed("ShotgunInp") and Globals.Items[Weapon][Shotgun] and $Cooldown.is_stopped() and (!Jammed or (Jammed and OneTimeAmmo)):
		OneTimeAmmo = false
		$AnimatedSprite2D.visible = true
		$Cooldown.start(Weapons[Type][Cd])
		$CooldownFloor.start(TIME_FLOOR)
		Attack(Type)
		AnimationTimer.start()

func _physics_process(delta):
	if PNode.is_on_floor() and $CooldownFloor.is_stopped():
		OnFloor = true
		GotOnFloor()
	else:
		OnFloor = false

const SHOTGUN_VEL = 700.0

func Attack(type):
	MakeBullets()
	
	SignalBus.emit_signal("ShotgunUse",SHOTGUN_VEL)
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D.frame = 0
	$HitSE.play()
	$Area2D/CollisionPolygon2D.set_deferred("disabled",false)
	
	HitboxTimer.start()
	#await HitboxTimer.timeout

func _on_area_2d_area_entered(area):
	if area.is_in_group("Enemy"):
		var MNode = Globals.GetParentWithMethod(area,"get_dmg")
		if MNode == null:
			return
		MNode.get_dmg(Weapons[Type][Dmg])

func _on_area_2d_body_entered(body):
	if body.is_in_group("enttree"):
		body.queue_free()

func AnimTimerTimeout():
	$AnimatedSprite2D.visible = false

func MakeBullets():
	var SBInst = ShotgunBulletsScene.instantiate()
	SBInst.global_position = global_position
	if PNode:
		SBInst.global_scale.x = PNode.LastDir
	else:
		PNode = get_tree().get_first_node_in_group("player")
	get_tree().root.add_child(SBInst)

func RESET():
	OneTimeAmmo = false
	$HitSE.stop()
	$Cooldown.stop()
	$AnimatedSprite2D.visible = false


func StopCD():
	$Cooldown.stop()
	SignalBus.emit_signal("ShotgunTimerHudUpdate",0.0,$Cooldown.wait_time)

func GotOnFloor():
	var WTime = $Cooldown.wait_time
	var TLeft = $Cooldown.time_left
	var TPass = WTime - TLeft
	var TLeftGround = TIME_FLOOR - TPass
	if TLeftGround <= 0.0:
		StopCD()
	else:
		pass

func _on_hitbox_time_timeout():
	$Area2D/CollisionPolygon2D.set_deferred("disabled",true)
