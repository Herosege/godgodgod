extends Area2D

func _ready():
	body_entered.connect(OnBodyEnter)
	body_exited.connect(OnBodyExit)


func OnBodyEnter(body):
	if body.is_in_group("player"):
		body.GravMultiplier = 0.1
		body.velocity.y *= 0.3

func OnBodyExit(body):
	if body.is_in_group("player"):
		body.GravMultiplier = 1.0
