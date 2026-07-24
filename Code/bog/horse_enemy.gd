extends CharacterBody2D

@onready var PNode = get_tree().get_first_node_in_group("player")

@export var TimePeak : float 
@export var TimeFall : float
@export var JumpStr : float
@onready var JVel = -(2.0 * JumpStr) / TimePeak
@onready var JGrav = -(-2.0 * JumpStr) / pow(TimePeak,2)
@onready var FGrav = -(-2.0 * JumpStr) / pow(TimeFall,2)

var InitScale

var VertSpeed = 70

var JumpAmount = 1

var BasePos

var Health := 3

var PlayerDetected = false
var PlayerInSight = false

var Active := true

func _ready():
	BasePos = global_position
	InitScale = $Sprite.scale

func _process(delta):
	pass

var Dir := 0

func _physics_process(delta):
	if Active:
		Dir = 0
		if PlayerDetected:
			Dir = sign(PNode.global_position.x-global_position.x)
		if Dir != 0:
			$Sprite.scale.x = Dir * InitScale.x
		if PNode:
			velocity.x = Dir * VertSpeed
		
		CheckRaycastColl()
		if PNode and PlayerInSight:
			if PNode.global_position.y < global_position.y and JumpAmount>0:
				Jump()
		if is_on_floor():
			JumpAmount = 1
	
	velocity.y += GetGravity() * delta
	move_and_slide()

func CheckRaycastColl():
	for i in $RayCasts.get_children():
		var Coll = i.get_collider()
		if Coll and JumpAmount>0:
			Jump()

func GetGravity():
	return JGrav if velocity.y < 0 else FGrav 

func Jump():
	JumpAmount = 0
	velocity.y = JVel

func _on_area_2d_2_body_entered(body):
	if body.is_in_group("player") and Active:
		PlayerInSight = true

func _on_area_2d_2_body_exited(body):
	if body.is_in_group("player"):
		PlayerInSight = false


func _on_detrange_body_entered(body):
	if body.is_in_group("player") and Active:
		$LoseSightTimer.stop()
		PlayerDetected = true
		$Sprite/AnimationPlayer.play("walking")


func _on_detrange_body_exited(body):
	if body.is_in_group("player"):
		$LoseSightTimer.start()
		

func RESET():
	Active = false
	$ActiveCd.start()
	Health = 3
	global_position = BasePos
	velocity = Vector2.ZERO
	$Sprite/AnimationPlayer.play("RESET")
	visible = true
	PlayerInSight = false
	PlayerDetected = false
	$Area2D/CollisionShape2D.set_deferred("disabled",false)
	$Area2D2/CollisionShape2D.set_deferred("disabled",false)
	$detrange/CollisionShape2D.set_deferred("disabled",false)
	$CollisionShape2D.set_deferred("disabled",false)


func _on_lose_sight_timer_timeout():
	PlayerInSight = false
	PlayerDetected = false
	$Sprite/AnimationPlayer.play("RESET")

func Die():
	Active = false
	$Area2D/CollisionShape2D.set_deferred("disabled",true)
	$Area2D2/CollisionShape2D.set_deferred("disabled",true)
	$detrange/CollisionShape2D.set_deferred("disabled",true)
	$CollisionShape2D.set_deferred("disabled",true)
	SignalBus.emit_signal("EnemyKilled",0)
	visible = false
	PlayerInSight = false
	PlayerDetected = false
	global_position = BasePos
	velocity = Vector2.ZERO
	


func _on_area_2d_take_damage_area_entered(area):
	if area.is_in_group("damage"):
		Health -= 1;
		global_position.x += Dir * 15
		$AnimationPlayer.play("damaged")
		if Health <= 0:
			Die()


func _on_active_cd_timeout():
	Active = true
	PlayerInSight = false
	PlayerDetected = false
