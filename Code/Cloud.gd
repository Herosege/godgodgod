extends StaticBody2D

@export var type : int = 0

func _ready():
	if type == 1:
		$AnimatedSprite2D.animation = "angry"
		$Area2D.add_to_group("killplayer")
		SignalBus.ScreenShaderChange.connect(OnScreenShaderChange)

func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and type == 0:
		$AnimatedSprite2D.frame = 1
	#if body.is_in_group("player") and type == 1:
		#SignalBus.emit_signal("Death")

func _on_area_2d_body_exited(body):
	if body.is_in_group("player") and type == 0:
		$AnimatedSprite2D.frame = 0

func OnScreenShaderChange(val,type):
	if type==Globals.Beer:
		if val:
			$Area2D.remove_from_group("killplayer")
		else:
			$Area2D.add_to_group("killplayer")
