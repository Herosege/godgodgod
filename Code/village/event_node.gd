extends Node2D

@export var CollShape : Shape2D
@export_multiline var Text0 : Array[String]
@export_multiline var Text1 : Array[String]
@export_multiline var Text2 : Array[String]

var Text : Array

var Activar = false
var CanDial = true

var CDialIndex = 0

func _ready():
	if Text0:
		Text.append(Text0)
	if Text1:
		Text.append(Text1)
	if Text2:
		Text.append(Text2)
	if CollShape:
		$Area2D/CollisionShape2D.shape = CollShape
	SignalBus.DialFinish.connect(OnDialFinish)

func _process(delta):
	if Input.is_action_just_pressed("Confirm") and Activar and CanDial and !Globals.InDialogue:
		TextSend()

func TextSend():
	if !Text:
		return
	var PNode = get_tree().get_first_node_in_group("player")
	var OnBottom := true
	if PNode:
		if PNode.CRoomPos.y:
			OnBottom = (PNode.global_position.y / PNode.CRoomPos.y) < (PNode.VPort.y / 2)
		else:
			OnBottom = PNode.global_position.y < (PNode.VPort.y / 2)
	SignalBus.emit_signal("ShowDialogue",Text[CDialIndex],OnBottom)
	CanDial = false

func OnDialFinish(Early):
	await get_tree().create_timer(0.1).timeout
	CanDial = true
	if !Early and CDialIndex+1 < Text.size():
		CDialIndex += 1

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		Activar = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		Activar = false
		if Globals.InDialogue:
			SignalBus.emit_signal("DialStop",true)
