extends Node2D

@onready var PNode = get_tree().get_first_node_in_group("player")

var Activared = false
var Activar = false

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("Confirm") and Activar and !Activared:
		SignalBus.emit_signal("SetHudMessage","",0)
		$EndingStuff.EndGame(Globals.End.EndingWater)
		Activared = true


func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and !Activared:
		Activar = true
		$Stuff/Onen/Label.visible = true
		SignalBus.emit_signal("SetHudMessage","Press SPACE to talk\nPress TAB to end",0)

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		Activar = false
		$Stuff/Onen/Label.visible = false
		SignalBus.emit_signal("SetHudMessage","",0)
