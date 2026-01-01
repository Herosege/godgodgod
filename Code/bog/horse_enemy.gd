extends CharacterBody2D

@onready var PNode = get_tree().get_first_node_in_group("player")

@export var TimePeak : float 
@export var TimeFall : float
@export var JumpStr : float
@onready var JVel = -(2.0 * JumpStr) / TimePeak
@onready var JGrav = -(-2.0 * JumpStr) / pow(TimePeak,2)
@onready var FGrav = -(-2.0 * JumpStr) / pow(TimeFall,2)

var VertSpeed = 55

var JumpAmount = 1

var BasePos

func _ready():
	BasePos = global_position

func _process(delta):
	pass

func _physics_process(delta):
	var Dir = sign(PNode.global_position.x-global_position.x)
	if Dir != 0:
		$Sprite2D.scale.x = Dir * 0.25
	if PNode:
		velocity.x = Dir * VertSpeed
	velocity.y += GetGravity() * delta
	CheckRaycastColl()
	if PNode and PlayerInSight:
		if PNode.global_position.y < global_position.y and JumpAmount>0:
			Jump()
	if is_on_floor():
		JumpAmount = 1
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

func RESET():
	global_position = BasePos
	velocity = Vector2.ZERO

var PlayerInSight = false

func _on_area_2d_2_body_entered(body):
	if body.is_in_group("player"):
		PlayerInSight = true

func _on_area_2d_2_body_exited(body):
	if body.is_in_group("player"):
		PlayerInSight = false
