extends Area2D

var CanSave = false
@onready var SHint = get_tree().get_first_node_in_group("SHint")

func _ready():
	SignalBus.SettingChanged.connect(OnSettingChanged)
	SHint.text = "Press {0} to save".format([Globals.KeybindList["SaveInp"][1].trim_suffix(" (Physical)")])

func _process(delta):
	if CanSave and Input.is_action_just_pressed("SaveInp") and $SaveCD.is_stopped():
		Globals.SavedPos[0] = global_position
		Globals.SavedPos[1] = Globals.CArea
		$SaveCD.start()
		$SaveSE.play()
		SignalBus.emit_signal("Save",0)

func _on_body_entered(body):
	if body.is_in_group("player"):
		CanSave = true
		SHint.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		CanSave = false
		SHint.visible = false

func OnSettingChanged():
	SHint.text = "Press {0} to save".format([Globals.KeybindList["SaveInp"][1].trim_suffix(" (Physical)")])
