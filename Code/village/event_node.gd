extends Area2D

enum {Dialogue,ChangeScene}
@export_enum("Dialogue","ChangeScene") var Type 

@export_group("Dialogue")
@export var Dial : TextRes

@export_group("ChangeScene")
@export var WhereTo : String
@export var Coords : Vector2

var Text

var Activar = false
var CanDial = true

var CDialIndex = 0

var Coll 

func _ready():
	body_entered.connect(_on_area_2d_body_entered)
	body_exited.connect(_on_area_2d_body_exited)
	if Dial and Type == Dialogue:
		Text = Dial.ConvertToString()

func _process(delta):
	if Input.is_action_just_pressed("Confirm") and Activar and CanDial and !Globals.InDialogue:
		SignalBus.emit_signal("GetInDial",true,self,false)
		if Type == Dialogue:
			TextSend()
		if Type == ChangeScene:
			SceneChange()

func TextSend():
	if !Text:
		return
	var PNode = get_tree().get_first_node_in_group("player")
	var OnBottom := true
	if PNode:
		OnBottom = (int(PNode.global_position.y) % 480) > (PNode.VPort.y / 2)
	SignalBus.emit_signal("ShowDialogue",Text[CDialIndex],self,OnBottom)
	SignalBus.emit_signal("SetHudMessage","",0)
	CanDial = false

func OnDialFinish(Early):
	if !Early:
		SignalBus.emit_signal("SetHudMessage","Press space to interact",0)
	await get_tree().create_timer(0.1).timeout
	SignalBus.emit_signal("GetInDial",false,self,Early)
	CanDial = true
	if !Early and CDialIndex+1 < Text.size():
		CDialIndex += 1

func SceneChange():
	if !WhereTo:
		return
	if !Globals.CArea == Globals.AreaScenes.find(WhereTo):
		Globals.LoadScene(WhereTo)
		Globals.PosSetTravel = Coords
	else:
		SignalBus.emit_signal("SetPlayerPosition",Coords)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		SignalBus.emit_signal("SetHudMessage","Press space to interact",0)
		Activar = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		Activar = false
		SignalBus.emit_signal("SetHudMessage","",0)
		if Globals.InDialogue:
			SignalBus.emit_signal("DialStop",true)
