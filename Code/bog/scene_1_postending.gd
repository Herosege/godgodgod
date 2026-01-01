extends Node

var Balls = []
var BArr = []

@onready var BaseCont = $Stuff/Balls

const RotSpeed = 10.0


func _ready():
	Globals.CArea = 7
	for i in BaseCont.get_children():
		if i is Area2D:
			BArr.append(i)
			var TApp = GenBalls(i,BArr)
			Balls.append(TApp.duplicate())
			BArr.resize(0)

func GenBalls(BCont,BArr):
	for i in BCont.get_children():
		if i is Area2D:
			BArr.append(i)
			GenBalls(i,BArr)
			return BArr


func _physics_process(delta):
	for i in Balls.size():
		for j in Balls[i].size():
			Balls[i][j].rotation += delta * RotSpeed / ((j+1)*2)

func RESET():
	for i in Balls.size():
		for j in Balls[i].size():
			Balls[i][j].rotation = 0.0
