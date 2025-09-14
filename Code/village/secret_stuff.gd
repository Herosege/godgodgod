extends Node2D

###  RAT
var AttackingBalbina = false
var InAxeCutscene = false

@onready var CTimer = $Balbina/CutsceneTimer

func _on_cliff_bottom_body_entered(body):
	if body.is_in_group("player") and !InAxeCutscene:
		$Balbina/Label.visible = true


func _on_cliff_bottom_body_exited(body):
	if body.is_in_group("player") and !InAxeCutscene:
		$Balbina/Label.visible = false


func _on_cliff_bottom_area_entered(area):
	if area.is_in_group("damage") and !InAxeCutscene:
		if area.is_in_group("shotgun"):
			pass
		else:
			AxeCutscene()

func AxeCutscene():
	InAxeCutscene = true
	$Balbina/AnimationPlayer.play("AxeCutscene")
	$Balbina/BossWall.global_position.y -= 500
	$Balbina/CliffBottom.set_deferred("disabled",true)
	CTimer.start(8.0)
	await CTimer.timeout
	SignalBus.emit_signal("Death")

func ShotgunCutscene():
	pass

func RESET():
	InAxeCutscene = false
	CTimer.stop()
	$Balbina/AnimationPlayer.play("RESET")
	$Balbina/BossWall.global_position.y = 2706.0
	$Balbina/CliffBottom.set_deferred("disabled",false)
