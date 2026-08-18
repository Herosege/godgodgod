extends Area2D

func _ready():
	body_entered.connect(OnBodyEnter)


func OnBodyEnter(body):
	if body.is_in_group("player"):
		body.Gra
