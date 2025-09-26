extends Node2D

func _ready():
	$Timer.connect("timeout",OnTimerTimeout)

func OnTimerTimeout():
	if $Hallmaster.rotation >= PI*2:
		$Hallmaster.rotation = 0
	$Hallmaster.rotation += PI/4


func _on_hallmaster_speak_body_entered(body):
	if body.is_in_group("player") and Globals.SpecialItem:
		$Lore.visible = true

func _on_hallmaster_speak_body_exited(body):
	if body.is_in_group("player") and Globals.SpecialItem:
		$Lore.visible = false
