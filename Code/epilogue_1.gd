extends Node2D

func _ready():
	Globals.stoptime = true
	$EndingStuff.EndGame(Globals.End.EndingWater)
