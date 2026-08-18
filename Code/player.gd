extends CharacterBody2D

class_name PlayerMain

@onready var CoyTimer = get_node("Timers/CoyoteTimer")
@onready var BufTimer = get_node("Timers/BufferTimer")
@onready var RedGravTimer = get_node("Timers/ReduceGravityTimer")

#Jump
const MinVelY = 130
const initVertSpeed = 200
const FPS_PHYS := 60
const MAX_Y_VELOCITY = 1500

var CanBufferJump = false
var CanCoyote = false
var JumpAmount = 1

@export var TimePeak : float 
@export var TimeFall : float
@export var JumpStr : float
@onready var JVel = -(2.0 * JumpStr) / TimePeak
@onready var JGrav = -(-2.0 * JumpStr) / pow(TimePeak,2)
@onready var FGrav = -(-2.0 * JumpStr) / pow(TimeFall,2)

var GravMultiplier  := 1.0

var VertSpeed = 200
var AddVel : Vector2

var LastSave : Vector2

var CRoomPos = Vector2.ZERO
var VPort = Vector2(640,480)

var MovementVel : Vector2
var AdditVel : Vector2

var Immortalix

var ReduceGravity := false

func _ready():
	SignalBus.KillPlayer.connect(Die)
	SignalBus.ResetPos.connect(ResetPosition)
	SignalBus.GetWeapon.connect(GetWeapon)
	SignalBus.EnemyKilled.connect(OnEnemyKilled)
	SignalBus.LaunchPlayer.connect(OnLaunchPlayer)
	SignalBus.FOrbUse.connect(OnFOrbUse)
	SignalBus.SetPlayerPosition.connect(SetPos)
	SignalBus.ShotgunUse.connect(OnShotgunUse)
	
	if !Globals.PosSetTravel:
		position = Globals.SavedPos[0]
	else:
		position = Globals.PosSetTravel
		Globals.PosSetTravel = Vector2.ZERO
	CRoomPos.x = floor(global_position.x / VPort.x)
	CRoomPos.y = floor(global_position.y / VPort.y)

func _physics_process(delta):
	print(CRoomPos)
	CRoomPos.x = floor(global_position.x / VPort.x)
	CRoomPos.y = floor(global_position.y / VPort.y)
	
	if AddVel:
		AddVel = AddVel.lerp(Vector2(0,0),0.1)
	
	if !ReduceGravity:
		velocity.y += GetGravity() * delta * GravMultiplier
	else:
		velocity.y += GetGravity() * delta * ((RedGravTimer.wait_time - RedGravTimer.time_left)/RedGravTimer.wait_time) * GravMultiplier
	
	
	CheckInputs()
	MoveDirection(delta)
	
	velocity.y = clamp(velocity.y,-MAX_Y_VELOCITY,MAX_Y_VELOCITY)
	move_and_slide()
	
	if Immortalix:
		Immortalix = false

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

var LastDir := 1.0


func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_SHIFT and OS.is_debug_build() and not event.is_echo():
			position.y -= 200
			velocity.y = 0
	#if event and not event.is_echo():
		#print("bark")

func MoveDirection(delta):
	
	var direction = Input.get_axis("LeftInp", "RightInp")
	
	if direction:
		LastDir = direction
	
	#debug
	
	if OS.is_debug_build():
		if Input.is_action_just_pressed("debug"):
			JumpAmount = 9999
			position.x += 220 * direction

	#enddebug
	
	if Input.is_action_pressed("Slowdown") and Globals.Items[Globals.Passive][Globals.Milk]:
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
		AdditVel.x = lerp(AdditVel.x, 0.0, 0.20)
		AdditVel.y = move_toward(AdditVel.y, 0.0, (initVertSpeed/8.0)*(FPS_PHYS*delta))
	else:
		MovementVel.x = lerp(MovementVel.x, 0.0, 0.49)
		#AdditVel.x = lerp(AdditVel.x, 0.0, 0.06)
		AdditVel.y = move_toward(AdditVel.y, 0.0, (initVertSpeed/6.0)*(FPS_PHYS*delta))
		AdditVel.x = move_toward(AdditVel.x, 0.0, (initVertSpeed/12.0)*(FPS_PHYS*delta))
	if is_on_wall():
		AdditVel.x = lerp(AdditVel.x, 0.0, 0.65)
	if is_on_ceiling():
		AdditVel.y = lerp(AdditVel.y, 0.0, 0.50)
	#velocity.y += AdditVel.y
	if AdditVel.y:
		velocity.y = AdditVel.y
	velocity.x = MovementVel.x + AdditVel.x

#Timers

func _on_coyote_timer_timeout():
	JumpAmount = 1

func GetVelocity(StdVel):
	return StdVel 

func _on_buffer_timer_timeout():
	CanBufferJump = false

func ResetPosition():
	#await get_tree().process_frame
	$BloodParticles.visible = false
	position = Globals.SavedPos[0]

func SetPos(Pos):
	global_position = Pos

func Die():
	get_tree().paused = true
	Globals.NumDeaths += 1
	velocity = Vector2(0,0)
	Globals.DisableAction = true
	$AnimatedSprite2D.visible = false
	$BloodParticles.restart()
	$BloodParticles.visible = true
	SignalBus.emit_signal("Death")

func Jump():
	velocity.y = JVel
	AdditVel.y = 0.0
	JumpAmount -= 1
	$JumpSE.play()
	if !Input.is_action_pressed("JumpInp") and velocity.y < 0.0: 
		velocity.y /= 3
	CanBufferJump = false

func GetWeapon(type):
	Globals.HasWeapon[type] = true

func OnEnemyKilled(type):
	match type:
		0:
			if JumpAmount == 0:
				JumpAmount = 1

func OnLaunchPlayer(Vel,Str):
	AdditVel.x = Vel.x * initVertSpeed * Str
	velocity.y = Vel.y * JumpStr * Str * 2.2

const FOrbVelocity = -750

func OnFOrbUse():
	velocity.y = 0.0
	if !ReduceGravity:
		AdditVel.y = FOrbVelocity
	else:
		AdditVel.y = FOrbVelocity * 1.25
	

func OnShotgunUse(Vel):
	velocity.y -= 200
	if sign(-LastDir) != sign(AdditVel.x):
		AdditVel.x = Vel * -LastDir
	else:
		AdditVel.x += Vel * -LastDir
	

func _on_area_2d_area_entered(area):
	if area.is_in_group("killplayer") and !Immortalix:
		Die()

func ActivarReduceGravity():
	ReduceGravity = true
	RedGravTimer.start()

func RESET():
	ReduceGravity = false
	CanBufferJump = false
	CanCoyote = false
	JumpAmount = 1
	velocity = Vector2.ZERO
	AdditVel = Vector2.ZERO


func _on_reduce_gravity_timer_timeout():
	ReduceGravity = false
