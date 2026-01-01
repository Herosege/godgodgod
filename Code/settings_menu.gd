extends Control

@onready var AVSl = $Settings/MarginContainer/VBoxContainer/HBoxContainer5/AVSl
@onready var SEVSl = $Settings/MarginContainer/VBoxContainer/HBoxContainer6/AVSl2
@onready var TCBox = $Settings/MarginContainer/VBoxContainer/HBoxContainer/CheckBox

@onready var Msg = $Settings/MessageOfTheDay


var CoolMsg = [
	"There are secrets all around you",
	"The sun is shining",
	"Reality is subjective",
	"Hania is always watching",
	"Horses are weak in this world",
	"Flowers are hateful",
	"Your mind is a beautiful world"
]

func _ready():
	$Keybinds.visible = false
	TCBox.button_pressed = Globals.TimerOn
	AVSl.value = Globals.MVol
	SEVSl.value = Globals.SEVol
	

func _on_exit_button_pressed():
	Globals.LoadKeybinds()
	Msg.text = CoolMsg.pick_random()
	SignalBus.emit_signal("SettingChanged")
	Globals.save_game("user://config.conf",{
	"MusicVolume":Globals.MVol,
	"SoundEffectVolume":Globals.SEVol,
	"TimerOn":Globals.TimerOn,
	"Keybinds":Globals.KeybindList
	})
	visible = false

func _on_av_sl_value_changed(value):
	$Settings/MarginContainer/VBoxContainer/HBoxContainer5/Label2.text = str(value)
	Globals.MVol = value
	AudioServer.set_bus_volume_db(0,(value/4)-15)
	AudioServer.set_bus_mute(0,!value)

func _on_av_sl_2_value_changed(value):
	$Settings/MarginContainer/VBoxContainer/HBoxContainer6/Label2.text = str(value)
	Globals.SEVol = value
	AudioServer.set_bus_volume_db(1,(value/4)-15)
	AudioServer.set_bus_mute(1,!value)

func _on_check_box_toggled(toggled_on):
	Globals.TimerOn = toggled_on


func _on_keybinds_pressed():
	$Keybinds.visible = true
