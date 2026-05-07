extends Node2D

var Balls = []

var Rot = [0.1,0.15,0.075]
var angle = [0.0,0.0,0.0]
var dis = [120,120,120]

var Positions = []

func _ready():
	Balls = get_children()
	Positions.resize(0)
	for i in Balls.size():
		Positions.append(Balls[i].global_transform)

func _physics_process(delta):
#func _process(delta):
	for i in Balls.size():
		Balls[i].get_node("Sprite2D").rotation += delta * 5
	for i in Balls.size() - 1:
		angle[i] = Balls[i].rotation * 0.36
		Balls[i].position = Balls[i+1].position + Vector2(cos(angle[i]),sin(angle[i])) * dis[i]
		Balls[i].rotation += Rot[i] * delta * 120

func _on_area_2d_body_entered(body):
	pass

func RESET():
	Balls = get_children()
	angle = [0.0,0.0,0.0]
	for i in Balls.size():
		Balls[i].global_transform = Positions[i]
