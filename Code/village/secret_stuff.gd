extends Node2D

###  RAT
var AttackingBalbina = false
var InAxeCutscene = false

func _on_cliff_bottom_body_entered(body):
	if body.is_in_group("player") and !InAxeCutscene:
		$Balbina/Label.visible = true


func _on_cliff_bottom_body_exited(body):
	if body.is_in_group("player") and !InAxeCutscene:
		$Balbina/Label.visible = false


func _on_cliff_bottom_area_entered(area):
	if area.is_in_group("damage") and !InAxeCutscene:
		AxeCutscene()

func AxeCutscene():
	InAxeCutscene = true
	$Balbina/AnimationPlayer.play("AxeCutscene")
	$Balbina/BossWall.global_position.y -= 500
	$Balbina/CliffBottom.call_deferred("queue_free")
	await get_tree().create_timer(8.0).timeout
	SignalBus.emit_signal("Death")
