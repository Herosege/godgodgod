extends Node2D

func _on_jackpottimer_timeout():
	$Timer.wait_time = 0.7
	$CanvasLayer/GPUParticles2D.emitting = false

func _on_timer_timeout():
	$CanvasLayer/Label.visible = !$CanvasLayer/Label.visible

func _on_music_finished():
	$Timer.start()
	$jackpottimer.start()
	$CanvasLayer/GPUParticles2D.emitting = true
