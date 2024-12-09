extends Node2D


enum {Passive,Weapon}
enum {Axe,Gun,Shotgun}

var CurWeapon = Axe

enum {Dmg,Cd}

var Weapons = [
	[1.75,0.05]
]

func _ready():
	$AnimatedSprite2D.visible = false
	$AnimatedSprite2D.play("default")
	$Area2D/CollisionShape2D.set_deferred("disabled",true)
	SignalBus.ScreenShaderChange.connect(_on_change_effect)

func _process(delta):
	if Input.is_action_just_pressed("AttackInp") and Globals.Items[Weapon][Axe] and $Cooldown.is_stopped():
		$AnimatedSprite2D.visible = true
		Attack(CurWeapon)
		$Cooldown.start()

func Attack(type):
	if type == Axe:
		$AnimatedSprite2D.play("Attack")
		$AnimatedSprite2D.frame = 0
		$HitSE.play()
		$Area2D/CollisionShape2D.set_deferred("disabled",false)
		await get_tree().create_timer(0.05).timeout
		$Area2D/CollisionShape2D.set_deferred("disabled",true)

func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D.visible = false

func _on_area_2d_area_entered(area):
	if area.is_in_group("Enemy"):
		area.get_parent().get_dmg(Weapons[CurWeapon][Dmg])

func _on_change_effect(value,type):
	Weapons[Axe][Dmg] = 1.75+(int(value)*0.75)

func _on_area_2d_body_entered(body):
	if body.is_in_group("enttree"):
		body.queue_free()
