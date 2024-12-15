extends Node2D

@onready var Cam = get_tree().get_first_node_in_group("cam")
@onready var PNode = get_tree().get_first_node_in_group("player")

var VPort = Vector2(640,480)

func _ready():
	UpdateCam()

func _process(delta):
	UpdateCam()

func UpdateCam():
	Cam.global_position.x = (VPort.x / 2) + VPort.x * floor(PNode.global_position.x / VPort.x)
	Cam.global_position.y = (VPort.y / 2) + VPort.y * floor(PNode.global_position.y / VPort.y)
