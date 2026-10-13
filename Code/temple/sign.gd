extends Area2D

@export_multiline var Text : String

@onready var PNode = get_tree().get_first_node_in_group("player")

func _ready():
	body_entered.connect(on_body_enter)
	body_exited.connect(on_body_exit)

func on_body_enter(body):
	if body.is_in_group("player"):
		var OnBottom := true
		if PNode:
			var pos = int(PNode.global_position.y) % 480
			if pos >= 0:
				OnBottom = pos < (PNode.VPort.y / 2)
			else:
				OnBottom = pos > (PNode.VPort.y / 2)
		
		SignalBus.HudSignShow.emit(Text,OnBottom)

func on_body_exit(body):
	if body.is_in_group("player"):
		SignalBus.HudSignShow.emit("")
