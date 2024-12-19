extends CharacterBody2D

class_name PlayerMain

@onready var CoyTimer = get_node("Timers/CoyoteTimer")
@onready var BufTimer = get_node("Timers/BufferTimer")

#Jump
const MinVelY = 130
const initVertSpeed = 200

var CanBufferJump = false
var CanCoyote = false
var JumpAmount = 1

@export var TimePeak : float 
@export var TimeFall : float
@export var JumpStr : float
@onready var JVel = -(2.0 * JumpStr) / TimePeak
@onready var JGrav = -(-2.0 * JumpStr) / pow(TimePeak,2)
@onready var FGrav = -(-2.0 * JumpStr) / pow(TimeFall,2)

var VertSpeed = 200
var AddVel : Vector2

var LastSave : Vector2

var CRoomPos = Vector2.ZERO
var VPort = Vector2(640,480)

var MovementVel : Vector2
var AdditVel : Vector2

func _ready():
	position = Globals.SavedPos[0]
	CRoomPos.x = floor(global_position.x / VPort.x)
	CRoomPos.y = floor(global_position.y / VPort.y)
	#global_position = Vector2(2050,400)
	SignalBus.Death.connect(_on_die)
	SignalBus.ResetPos.connect(ResetPosition)
	SignalBus.GetWeapon.connect(GetWeapon)
	SignalBus.EnemyKilled.connect(OnEnemyKilled)
	SignalBus.LaunchPlayer.connect(OnLaunchPlayer)

func _physics_process(delta):
	CRoomPos.x = floor(global_position.x / VPort.x)
	CRoomPos.y = floor(global_position.y / VPort.y)
	
	if AddVel:
		AddVel = AddVel.lerp(Vector2(0,0),0.1)
	velocity.y += GetGravity() * delta
	velocity.y = clamp(velocity.y,-2000,2000)
	
	CheckInputs()
	MoveDirection()
	
	move_and_slide()

func GetGravity():
	return JGrav if velocity.y < 0 else FGrav 

func CheckInputs():
	if is_on_floor():
		JumpAmount = 2
		CanCoyote = true
	
	if !is_on_floor() and CanCoyote:
		CoyTimer.start() 
		CanCoyote = false
	
	if Input.is_action_just_pressed("JumpInp") and !is_on_floor():
		if BufTimer.is_stopped():
			CanBufferJump = true
			BufTimer.start()
	
	if (Input.is_action_just_pressed("JumpInp") and JumpAmount != 0) or (CanBufferJump and is_on_floor()):
		Jump()
	
	if Input.is_action_just_released("JumpInp") and velocity.y < 0.0:
		velocity.y /= 3

func MoveDirection():
	
	var direction = Input.get_axis("LeftInp", "RightInp")
	if Input.is_action_pressed("Slowdown") and Globals.EffectActive[Globals.Milk]:
		VertSpeed = 25
	else:
		VertSpeed = 200
	
	if direction:
		MovementVel.x += direction * VertSpeed + AddVel.x / 10
		$AnimatedSprite2D.scale.x = direction
		$AnimatedSprite2D.animation = "walking" 
	else:
		$AnimatedSprite2D.animation = "standard"
		MovementVel.x = lerp(MovementVel.x , 0.0, 0.9)
	#if is_on_floor():
		#velocity.x = move_toward(velocity.x, 0, VertSpeed/1.5)
	#else:
		#velocity.x = move_toward(velocity.x, 0, VertSpeed/10)
	if is_on_floor():
		MovementVel.x = lerp(MovementVel.x, 0.0, 0.54)
		AdditVel.x = lerp(AdditVel.x, 0.0, 0.50)
	else:
		MovementVel.x = lerp(MovementVel.x, 0.0, 0.49)
		#AdditVel.x = lerp(AdditVel.x, 0.0, 0.06)
		AdditVel.x = move_toward(AdditVel.x, 0, initVertSpeed/10)
	if is_on_wall():
		AdditVel.x = lerp(AdditVel.x, 0.0, 0.50)
	
	velocity.x = MovementVel.x + AdditVel.x

#Timers

func _on_coyote_timer_timeout():
	JumpAmount = 1;

func GetVelocity(StdVel):
	return StdVel 

func _on_buffer_timer_timeout():
	CanBufferJump = false

func Die():
	Globals.NumDeaths += 1
	velocity = Vector2(0,0)
	Globals.DisableAction = true
	get_tree().paused = true
	$AnimatedSprite2D.visible = false
	$BloodParticles.visible = true
	$BloodParticles.emitting = true
	$BloodParticles.restart()

func ResetPosition():
	$BloodParticles.visible = false
	position = Globals.SavedPos[0]

func Jump():
	velocity.y = JVel
	JumpAmount -= 1
	$JumpSE.play()
	if !Input.is_action_pressed("JumpInp") and velocity.y < 0.0: 
		velocity.y /= 3
	CanBufferJump = false

func _on_die():
	Die()

func GetWeapon(type):
	Globals.HasWeapon[type] = true

func _on_boss_trigger_body_entered(body):
	if body.is_in_group("player"):
		SignalBus.emit_signal("TriggerBoss",1)

func OnEnemyKilled(type):
	match type:
		0:
			if JumpAmount == 0:
				JumpAmount = 1

func OnLaunchPlayer(Vel,Str):
	AdditVel.x = Vel.x * initVertSpeed * Str
	velocity.y = Vel.y * JumpStr * Str * 2.2

func _on_area_2d_area_entered(area):
	if area.is_in_group("killplayer"):
		Die()
