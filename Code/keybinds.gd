extends Control

@onready var Cont = $Panel/MarginContainer/VBoxContainer

var InputArr = [
	"LeftInp",
	"RightInp",
	"JumpInp",
	"AttackInp",
	"ShotgunInp",
	"Slowdown",
	"ResetInp",
	"SaveInp"
]

var HBoxes = []

var Remapping = false

func _ready():
	
	await get_tree().process_frame
	for i in Cont.get_children():
		if i is HBoxContainer:
			HBoxes.append(i)
	if Globals.KeybindList:
		GenActions()
	else:
		GenActionsFT()
	for i in HBoxes.size():
		var Btn = HBoxes[i].get_node("Button")
		Btn.pressed.connect(OnPressed.bind(Btn))

func GenActionsFT():
	for i in InputArr.size():
		var Action = InputMap.action_get_events(InputArr[i])
		var TextTS = Action[0].as_text_physical_keycode()
		HBoxes[i].get_node("Label2").text = TextTS
		Globals.KeybindList[InputArr[i]] = []
		Globals.KeybindList[InputArr[i]].append(Action[0].physical_keycode)
		Globals.KeybindList[InputArr[i]].append(Action[0].as_text_physical_keycode())

func GenActions():
	for i in InputArr.size():
		var Action = Globals.KeybindList[InputArr[i]][1]
		var TextTS = Action
		HBoxes[i].get_node("Label2").text = TextTS

var ActionRemapped
var HBoxRem

func OnPressed(button):
	if !Remapping:
		Remapping = true
		var ID = HBoxes.find(button.get_parent())
		ActionRemapped = InputArr[ID]
		HBoxRem = HBoxes[ID]
		HBoxRem.get_node("Label2").text = "Press a key to bind..."

func _input(event):
	if Remapping and (event is InputEventKey and event.is_pressed()):
		InputMap.action_erase_events(ActionRemapped)
		InputMap.action_add_event(ActionRemapped,event)
		UpdateActions(HBoxRem,event)

func UpdateActions(HBox,event):
	HBox.get_node("Label2").text = event.as_text()
	Globals.KeybindList[InputArr[HBoxes.find(HBox)]][0] = event.physical_keycode
	Globals.KeybindList[InputArr[HBoxes.find(HBox)]][1] = event.as_text()
	Remapping = false
	SignalBus.emit_signal("SettingChanged")


func _on_exit_btn_pressed():
	visible = false
	
