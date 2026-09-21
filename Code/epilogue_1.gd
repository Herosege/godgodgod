extends Node2D

func _ready():
	Globals.stoptime = true
	await $Timer.timeout
	$EndingStuff.EndGame(Globals.End.EndingWater)
