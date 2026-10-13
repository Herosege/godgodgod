extends Node2D

@export var NoiseTex : NoiseTexture2D
@export var Nois : Noise

@onready var NTimer = $AbsvoidStuff/NoiseTimer
@onready var NAudio = $AbsvoidStuff/Noise
@onready var NBG = $AbsvoidStuff/NoiseBG

@onready var InitTimer = $AbsvoidStuff/InitTimer
@onready var TTimer = $AbsvoidStuff/TransitionTimer
@onready var TAudio = $AbsvoidStuff/TransitionAudio

var FullInVoid := true

var InAbsVoid := true :
	set(val):
		if val:
			NTimer.start((randf()*1.2)+0.05)
		else:
			NTimer.stop()
		NAudio.playing = val
		NBG.visible = val
		InAbsVoid = val


#left x,up y,right x,down y - In rooms 
const AbsVoidBorders = Vector4(1,1,4,1)

@onready var PNode = get_tree().get_first_node_in_group("player")

func _ready():
	Globals.CArea = 9
	if STEvents.EventArray[STEvents.Enums.FTVoid]:
		InitTimer.start(2)
	InitTimer.timeout.connect(OnInitTimerTimeout)
	NTimer.timeout.connect(OnNoiseTimerTimeout)
	TTimer.timeout.connect(OnTransitTimerTimeout)
	NTimer.start(randf()+0.05)
	NoiseTex.noise = Nois
	

func _process(delta):
	if PNode:
		if PNode.CRoomPos.x >= AbsVoidBorders.x and PNode.CRoomPos.y >= AbsVoidBorders.y and PNode.CRoomPos.x <= AbsVoidBorders.z and PNode.CRoomPos.y <= AbsVoidBorders.w:
			InAbsVoid = false
		else:
			if !InAbsVoid:
				InAbsVoid = true

func _physics_process(delta):
	if FullInVoid:
		PNode.position.x = wrapf(PNode.position.x,0.0,640.0)
		PNode.position.y = wrapf(PNode.position.y,0.0,480.0)

func OnNoiseTimerTimeout():
	NTimer.start((randf()*1.2)+0.05)
	Nois.seed = randi_range(0,21232323)
	if InAbsVoid:
		NAudio.pitch_scale = randf()*0.75

func OnTransitTimerTimeout():
	TAudio.stop()
	STEvents.EventArray[STEvents.Enums.FTVoid] = true
	InAbsVoid = false
	FullInVoid = false
	if PNode:
		PNode.position = Vector2(1454,872)
	$AbsvoidStuff/CanvasLayer/ColorRect.queue_free()

func OnInitTimerTimeout():
	TTimer.start()
	TAudio.play()
	$AbsvoidStuff/AnimationPlayer.play("flash")


func _on_onen_body_entered(body):
	if body.is_in_group("player"):
		$Stuff/Onen/Label.visible = true
