extends Node2D



func _on_heart_area_entered(area):
	if area.is_in_group("damage"):
		queue_free()
		SignalBus.emit_signal("BossHeartDamage",5.0)
