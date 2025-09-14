extends Node2D

@export_enum("Axe","Shotgun") var Type

@onready var AnimationTimer = $AnimationTime
@onready var HitboxTimer = $HitboxTime

enum {Passive,Weapon}
enum {Axe,Shotgun}

var CurWeapon = Axe

enum {Dmg,Cd}

var Weapons = [
	[AXE_DMG,0.125],
	[SHOTGUN_DMG,2.5]
]

const AXE_DMG = 1.0
const SHOTGUN_DMG = 3.0

var AnimTime

func _ready():
	AnimTime = $AnimatedSprite2D.sprite_frames.get_frame_count("default") / $AnimatedSprite2D.sprite_frames.get_animation_speed("default")
	AnimationTimer.wait_time = AnimTime
	$Area2D/CollisionShape2D.set_deferred("disabled",true)
	$AnimatedSprite2D.visible = false
	
	SignalBus.ScreenShaderChange.connect(_on_change_effect)
	
	AnimationTimer.connect("timeout",AnimTimerTimeout)

func _process(delta):
	if Input.is_action_just_pressed("AttackInp") and Globals.Items[Weapon][Axe] and $Cooldown.is_stopped():
		$AnimatedSprite2D.visible = true
		Attack(Type)
		AnimationTimer.start()
		$Cooldown.start()

func Attack(type):
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D.frame = 0
	$HitSE.play()
	$Area2D/CollisionShape2D.set_deferred("disabled",false)
	HitboxTimer.start()
	await HitboxTimer.timeout
	$Area2D/CollisionShape2D.set_deferred("disabled",true)

func _on_area_2d_area_entered(area):
	if area.is_in_group("Enemy"):
		area.get_parent().get_dmg(Weapons[Type][Dmg])

func _on_change_effect(value,type):
	pass
	#Weapons[Axe][Dmg] = AXE_DMG if !Globals.EffectActive[Globals.Beer] else AXE_DMG*1.1
	#Weapons[Shotgun][Dmg] = SHOTGUN_DMG if !Globals.EffectActive[Globals.Beer] else SHOTGUN_DMG+0.5
	#print(Weapons[Axe][Dmg])

func _on_area_2d_body_entered(body):
	if body.is_in_group("enttree"):
		body.queue_free()

func AnimTimerTimeout():
	$AnimatedSprite2D.visible = false
