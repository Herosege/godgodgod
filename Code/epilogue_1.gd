extends Node2D

func _ready():
	Globals.stoptime = true

func _on_animated_sprite_2d_animation_finished():
	$EndingStuff.EndGame(Globals.End.EndingPain)
