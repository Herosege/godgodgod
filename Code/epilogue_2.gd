extends Node2D

@onready var PNode = get_tree().get_first_node_in_group("player")

var Activared = false
var Activar = false

func _ready():
	PNode.position = Vector2(470,-388)

func _process(delta):
	if Input.is_action_just_pressed("Confirm") and Activar and !Activared:
		SignalBus.emit_signal("SetHudMessage","",0)
		Globals.stoptime = true
		EndGame()


func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and !Activared:
		Activar = true
		$Henryk/Label.visible = true
		SignalBus.emit_signal("SetHudMessage","Press space to end",0)

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		Activar = false
		$Henryk/Label.visible = false
		SignalBus.emit_signal("SetHudMessage","",0)

func EndGame():
	Activared = true
	
	Globals.EndingHall = true
	Globals.NumTimesBeatGame += 1
	if Globals.SaveTime < Globals.BestTime or !Globals.BestTime:
		Globals.BestTime = Globals.SaveTime
	if Globals.NumDeaths < Globals.LDeaths or Globals.LDeaths == -1:
		Globals.LDeaths = Globals.NumDeaths
	
	var time = Globals.sec_to_time(Globals.SaveTime)
	var hrs = "" if !time[2] else str(time[2]) + " hours "
	var min = "" if !time[1] else str(time[1]) + " minutes "
	
	$CanvasLayer2/Label2.text = "Final time: " + hrs + min + str(time[0]) + " seconds"
	$CanvasLayer2/Label2.visible = true
	$CanvasLayer2/Label.visible = true
	
	$CanvasLayer2/Label3.text = "You died: " + str(Globals.NumDeaths) + " times"
	$CanvasLayer2/Label3.visible = true
	
	Globals.SavePerma()
	Globals.SaveData(666)
