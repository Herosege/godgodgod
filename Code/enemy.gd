extends Node2D

func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		SignalBus.emit_signal("LaunchPlayer",CalcLaunch(area.owner.global_position).normalized(),5.0)
	if area.is_in_group("damage"):
		SignalBus.emit_signal("EnemyKilled",0)
		Globals.EnemiesKilled += 1
		$AudioStreamPlayer.pitch_scale = 0.6 + (randf()*0.4)
		$AudioStreamPlayer.play()
		$Area2D.queue_free()
		$AnimatedSprite2D.stop()
		$AnimationPlayer.play("Die")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Die":
		queue_free()

func CalcLaunch(Pos):
	#with this enemy is now technically 0,0 and we now have the distance to player that we can 
	var equ = RoundNearest(atan2(Pos.x-global_position.x,Pos.y-global_position.y),PI/4)
	print(equ)
	return Vector2(sin(equ),cos(equ))
	#return Vector2(SpecRound(equ.x,PI/4),SpecRound(equ.y,PI/4))

func RoundNearest(val,base):
	return base * round(val/base)
