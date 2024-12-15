extends Node2D

func _ready():
	Globals.stoptime = true

func _on_s_timer_timeout():
	$Label1.text = "Final time: " + str(round(Globals.SaveTime*100)/100)
	$Label1.visible = true
	
	await get_tree().create_timer(3.2).timeout
	$music.stop()
