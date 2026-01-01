extends Node2D

var Avi = true

const LauchVel = 750.0

func _ready():
	pass

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and Avi:
		body.AdditVel.x += LauchVel*body.LastDir
		Avi = false
		$Timer.start()
		$AnimatedSprite2D.scale = Vector2(0.75,0.75)
		$AnimatedSprite2D.modulate = Color.BLACK


func _on_timer_timeout():
	Avi = true
	$AnimatedSprite2D.scale = Vector2(1.0,1.0)
	$AnimatedSprite2D.modulate = Color.WHITE

func RESET():
	Avi = true
	$AnimatedSprite2D.scale = Vector2(1.0,1.0)
	$AnimatedSprite2D.modulate = Color.WHITE
