extends StaticBody2D

@export var type : int = 0

func _ready():
	if type == 1:
		$AnimatedSprite2D.animation = "angry"

func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and type == 0:
		$AnimatedSprite2D.frame = 1
	if body.is_in_group("player") and type == 1:
		SignalBus.emit_signal("Death")

func _on_area_2d_body_exited(body):
	if body.is_in_group("player") and type == 0:
		$AnimatedSprite2D.frame = 0
