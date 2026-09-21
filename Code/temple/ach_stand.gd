extends Node2D

@export var Achiev_enum : STEvents.ACHIEVEMENT

var BodIn := false

var Achiev_res : Achievement

func _ready():
	Achiev_res = STEvents.Achievements[Achiev_enum]
	$AchSpr/ach.texture = Achiev_res.AchImage
	$AchSpr.visible = Achiev_res.Achieved
	$NA_sprite.visible = not Achiev_res.Achieved


func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		BodIn = true
		SignalBus.ExTextShow.emit(Achiev_res.Name)
		if Achiev_res.Achieved:
			SignalBus.HudSignShow.emit(Achiev_res.Description)

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		BodIn = false
		SignalBus.ExTextShow.emit("")
		if Achiev_res.Achieved:
			SignalBus.HudSignShow.emit("")
