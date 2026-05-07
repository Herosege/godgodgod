#extends Area2D
#
#var Available = true
#
#func _on_area_entered(area):
	#if area.is_in_group("damage") and Available:
		#Available = false
		#$Timer.start()
		#$AnimatedSprite2D.modulate = Color.BLACK
		#$AnimatedSprite2D.scale = Vector2(0.5,0.5)
		#SignalBus.emit_signal("FOrbUse")
#
#func RESET():
	#Available = true
	#$AnimatedSprite2D.modulate = Color.WHITE
	#$AnimatedSprite2D.scale = Vector2.ONE
#
#func _on_timer_timeout():
	#Available = true
	#$AnimatedSprite2D.modulate = Color.WHITE
	#$AnimatedSprite2D.scale = Vector2.ONE
extends Area2D

var Available = true

const MAX_FRAMES = 2

func _process(delta):
	$AnimatedSprite2D.frame = GAnimTimer.GlobalAnimFrame%MAX_FRAMES

func _on_area_entered(area):
	if area.is_in_group("damage") and Available:
		Available = false
		$Timer.start()
		$AnimatedSprite2D.play("not_avi")
		SignalBus.emit_signal("FOrbUse")

#var t := 0.0
#
#const TIME := 0.75
#
#func _process(delta):
	#t += delta
	#if t >= TIME:
		#t-=TIME
		#$AnimatedSprite2D.rotation += TAU / 4
		#if $AnimatedSprite2D.rotation >= TAU:
			#$AnimatedSprite2D.rotation -= TAU

func RESET():
	Available = true
	$AnimatedSprite2D.animation = "default"

func _on_timer_timeout():
	Available = true
	$AnimatedSprite2D.animation = "default"
