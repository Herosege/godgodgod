extends Control

@onready var AVSl = $Settings/MarginContainer/VBoxContainer/HBoxContainer5/AVSl
@onready var SEVSl = $Settings/MarginContainer/VBoxContainer/HBoxContainer6/AVSl2
@onready var TCBox = $Settings/MarginContainer/VBoxContainer/HBoxContainer/CheckBox

@onready var Msg = $Settings/MessageOfTheDay


var CoolMsg = [
	"The sun is watching",
	"All is vanity",
	"The world is a wonderful place",
	"Horses are dangerous",
	"Flowers are stingy",
	"Your mind is a beautiful world",
	"Think about light",
	"You are in the present",
	"What if it's all meaningless?"
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
	AudioServer.set_bus_volume_db(2,(value/4)-15)
	AudioServer.set_bus_mute(2,!value)

func _on_av_sl_2_value_changed(value):
	$Settings/MarginContainer/VBoxContainer/HBoxContainer6/Label2.text = str(value)
	Globals.SEVol = value
	AudioServer.set_bus_volume_db(1,(value/4)-15)
	AudioServer.set_bus_mute(1,!value)

func _on_check_box_toggled(toggled_on):
	Globals.TimerOn = toggled_on


func _on_keybinds_pressed():
	$Keybinds.visible = true
