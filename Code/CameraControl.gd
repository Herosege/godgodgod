extends Node2D

@onready var Cam = get_tree().get_first_node_in_group("cam")
@onready var PNode = get_tree().get_first_node_in_group("player")

var VPort = Vector2(640,480)

func _ready():
	UpdateCam()

var Zoomed := false

func _process(delta):
	UpdateCam()
	#if Input.is_action_just_pressed("debug") and OS.is_debug_build():
		#if not Zoomed:
			#Cam.zoom = Vector2(0.3,0.3)
			#Zoomed = true
		#else:
			#Cam.zoom = Vector2(1.0,1.0)
			#Zoomed = false

func UpdateCam():
	Cam.global_position.x = (VPort.x / 2) + VPort.x * floor(ceil(PNode.global_position.x) / VPort.x)
	Cam.global_position.y = (VPort.y / 2) + VPort.y * floor(ceil(PNode.global_position.y) / VPort.y)
