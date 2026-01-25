extends Node2D


func _on_animated_sprite_2d_animation_finished():
	$stuff/MEMORY.play()
	$EndingStuff.EndGame(Globals.End.EndingTravel,false,0)
