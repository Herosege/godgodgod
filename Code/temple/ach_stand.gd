extends Node2D

@export var Achiev_enum : STEvents.ACHIEVEMENT

@onready var PNode = get_tree().get_first_node_in_group("player")

var BodIn := false

var Achiev_res : Achievement

func _ready():
	Achiev_res = STEvents.Achievements[Achiev_enum]
	$AchSpr/ach.texture = Achiev_res.AchImage
	$AchSpr.visible = Achiev_res.Achieved
	$NA_sprite.visible = not Achiev_res.Achieved


func _process(delta):
	pass

func UpdateVisual():
	$AchSpr.visible = Achiev_res.Achieved
	$NA_sprite.visible = not Achiev_res.Achieved



func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		BodIn = true
		SignalBus.ExTextShow.emit(Achiev_res.Name)
		if Achiev_res.Achieved:
			var OnBottom := true
			if PNode:
				var pos = int(PNode.global_position.y) % 480
				if pos >= 0:
					OnBottom = pos < (PNode.VPort.y / 2)
				else:
					OnBottom = pos > (PNode.VPort.y / 2)
			SignalBus.HudSignShow.emit(Achiev_res.Description,OnBottom)

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		BodIn = false
		SignalBus.ExTextShow.emit("")
		if Achiev_res.Achieved:
			SignalBus.HudSignShow.emit("")
