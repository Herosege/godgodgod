extends Node2D

var Activare = false
var Activared = false

func _ready():
	Globals.stoptime = true

func _on_animated_sprite_2d_animation_finished():
	if !Activare:
		Activare = true
		$AnimatedSprite2D.play("sleeping")

func _on_timer_timeout():
	$CPUParticles2D.emitting = true


func _on_animated_sprite_2d_animation_looped():
	if !Activared:
		Activared = true
		$EndingStuff.EndGame(Globals.End.EndingPeace)
