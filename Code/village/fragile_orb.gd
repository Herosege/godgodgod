extends Area2D

var Available = true

func _on_area_entered(area):
	if area.is_in_group("damage") and Available:
		Available = false
		$Timer.start()
		$AnimatedSprite2D.play("not_avi")
		SignalBus.emit_signal("FOrbUse")

var t := 0.0

func _process(delta):
	t += delta
	if t >= 0.5:
		t-=0.5
		$AnimatedSprite2D.rotation += TAU / 4
		if $AnimatedSprite2D.rotation >= TAU:
			$AnimatedSprite2D.rotation -= TAU

func RESET():
	Available = true
	$AnimatedSprite2D.play("default")

func _on_timer_timeout():
	Available = true
	$AnimatedSprite2D.play("default")
