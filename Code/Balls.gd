extends Node2D

@onready var Balls = get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var Rot = [0.1,0.15,0.075]
var angle = [0.0,0.0,0.0]
var dis = [120,120,120]

func _process(delta):
	for i in Balls.size():
		Balls[i].get_node("Sprite2D").rotation += delta * 5
	for i in Balls.size() - 1:
		angle[i] = Balls[i].rotation * delta * 25
		Balls[i].position = Balls[i+1].position + Vector2(cos(angle[i]),sin(angle[i])) * dis[i]
		Balls[i].rotation += Rot[i] * delta * 120

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		SignalBus.emit_signal("Death")
