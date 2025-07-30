extends Area2D


func _on_area_entered(area):
	if area.is_in_group("damage"):
		$CollisionShape2D.set_deferred("disabled",true)
		$AnimatedSprite2D.visible = false
		SignalBus.emit_signal("FOrbUse")

var t := 0.0

func _process(delta):
	t += delta
	if t >= 0.25:
		t-=0.125
		$AnimatedSprite2D.rotation += TAU / 4
		if $AnimatedSprite2D.rotation >= TAU:
			$AnimatedSprite2D.rotation -= TAU

func RESET():
	$CollisionShape2D.set_deferred("disabled",false)
	$AnimatedSprite2D.visible = true
