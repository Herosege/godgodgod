extends Node2D

@onready var HBar = get_tree().get_first_node_in_group("healthbar")
@onready var PlayerNode = get_tree().get_first_node_in_group("player")

const InitHealth = 50.0
var Health = InitHealth

var CAtt = 0

var Activar = false

var TimeRed = 0

func _ready():
	SignalBus.BossDead.connect(_on_BossDead)
	HBar.value = 100.0
	position = Vector2(2240,368)
	SignalBus.TriggerBoss.connect(_on_Trigger_Boss)

var t = 0.0
var AttVariant = 0
const StepAmt = 640 / 9

func _process(delta):
	t += delta * 3.0
	if Activar:
		if $AttackTimer.is_stopped():
			var RandNum = randi()%3
			while RandNum == CAtt - 1:
				RandNum = randi()%3
			Attack(RandNum)
		
		if Health < InitHealth/3:
			TimeRed = 1
			$"../MusicBoss".pitch_scale = 1.2
		
		match CAtt:
			1:
				position = position.lerp(Vector2(2240,358),0.4)
				if $Att2Timer.is_stopped() and !$PreAtt2Timer.is_stopped():
					for i in 9-AttVariant:
						Shoot(Vector2(1920+(i*StepAmt)+(AttVariant*StepAmt),0) , Vector2(2000+i*StepAmt-AttVariant*StepAmt,580))
					$Att2Timer.start(0.42-(TimeRed*0.15))
					AttVariant += 1 
					AttVariant %= 2
			2:
				if $Att2Timer.is_stopped() and $PreAtt2Timer.is_stopped():
					Shoot(global_position,Vector2(PlayerNode.global_position.x+(PlayerNode.velocity.x/2),PlayerNode.global_position.y))
					$Att2Timer.start(0.3-(TimeRed*0.06))
				position.y = lerp(position.y,290.0 + (40.0 * sin(t)) ,0.6)
				position.x = lerp(position.x,PlayerNode.position.x,0.1)
				
			3:
				position = position.lerp(Vector2(2240,300),0.4)
				if $Att2Timer.is_stopped() and $PreAtt2Timer.is_stopped():
					for i in 12+AttVariant:
						Shoot(global_position, Vector2( cos( ( TAU / (12 + AttVariant) ) * i ) + global_position.x 
						, sin( ( TAU / (12 + AttVariant) ) * i ) + global_position.y) )
					$Att2Timer.start(0.5+(0.5*AttVariant)-(TimeRed*0.1))
					AttVariant += 1
					AttVariant %= 2
		
		if Health <= 0:
			$BossBloodParticles.emitting = true
			$deathsound.play()
			BossDeath()

func Attack(type):
	AttVariant = 0
	match type:
		0:
			$AttackTimer.start(5.0-(TimeRed*2))
			$PreAtt2Timer.start(3.0-(TimeRed*1))
			$AnimatedSprite2D.animation = "default"
			CAtt = 1
			pass
		1:
			$AttackTimer.start(4.0-(TimeRed*1))
			$PreAtt2Timer.start(0.7-(TimeRed*0.2))
			$AnimatedSprite2D.animation = "Spin"
			CAtt = 2
			pass
		2:
			$AttackTimer.start(3.5-(TimeRed*1))
			$PreAtt2Timer.start(0.5-(TimeRed*0.1))
			$AnimatedSprite2D.animation = "default"
			CAtt = 3
			pass

func _on_area_2d_area_entered(area):
	pass

func _on_att_2_timer_timeout():
	pass # Replace with function body.

func _on_Trigger_Boss(type):
	if type == 1:
		Activar = true
		

func BossDeath():
	HBar.visible = false
	Activar = false
	$"../BossWall/CollisionShape2D".set_deferred("disabled",true)
	$"../BossWall".visible = false
	$"../BossWall2/CollisionShape2D".set_deferred("disabled",true)
	$"../BossWall2".visible = false
	$"../MusicBoss".stop()
	for i in $"../Bullets".get_children():
		i.queue_free()
	Globals.BossKilled[Globals.VoidSpaghetti] = true
	$AnimatedSprite2D.visible = false

@onready var BulletScene = load("res://Scenes/bullet.tscn")

func Shoot(From,At):
	var BulInst = BulletScene.instantiate()
	BulInst.global_position = From
	BulInst.Towards = At
	$"../Bullets".add_child(BulInst)

func _on_BossDead(type):
	BossDeath()

func get_dmg(amt):
	Health -= amt
	HBar.value = (Health / InitHealth) * 100 
