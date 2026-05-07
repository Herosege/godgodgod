extends Node2D

###  RAT
var AttackingBalbina = false
var InAxeCutscene = false

@onready var CTimer = $Balbina/CutsceneTimer

func _ready():
	if Globals.BossKilled[Globals.Balbina] == true:
		$Balbina.queue_free()
		$Gate.queue_free()

func _on_cliff_bottom_body_entered(body):
	if body.is_in_group("player") and !InAxeCutscene:
		$Balbina/Label.visible = true


func _on_cliff_bottom_body_exited(body):
	if body.is_in_group("player") and !InAxeCutscene:
		$Balbina/Label.visible = false


func _on_cliff_bottom_area_entered(area):
	if area.is_in_group("damage"):
		if area.is_in_group("shotgun"):
			ShotgunCutscene()
			return
		if !InAxeCutscene:
			AxeCutscene()

func AxeCutscene():
	InAxeCutscene = true
	$Balbina/AnimationPlayer.play("AxeCutscene")
	$Balbina/BossWall.global_position.y -= 500
	CTimer.start(8.0)
	await CTimer.timeout
	SignalBus.emit_signal("KillPlayer")

func ShotgunCutscene():
	Globals.BossKilled[Globals.Balbina] = true
	$Balbina.queue_free()
	$RatStuff/DeathSound.play()
	$RatStuff/RatParticle.emitting = true
	$RatStuff/AnimationPlayer.play("GateOpen")

func RESET():
	if Globals.BossKilled[Globals.Balbina] == false:
		CTimer.stop()
		$Balbina/AnimationPlayer.play("RESET")
		$Balbina/BossWall.global_position.y = 2706.0
	InAxeCutscene = false
	
