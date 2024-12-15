extends Control

@onready var AVSl = $Settings/MarginContainer/VBoxContainer/HBoxContainer5/AVSl
@onready var SEVSl = $Settings/MarginContainer/VBoxContainer/HBoxContainer6/AVSl2
@onready var Msg = $Settings/MessageOfTheDay

var CoolMsg = [
	"There is a mage worm around these parts, it's silly and wiggles a lot",
	"God hates you"
]

func _ready():
	AVSl.value = Globals.MVol
	SEVSl.value = Globals.SEVol

func _on_exit_button_pressed():
	Msg.text = CoolMsg[0] if randf()>0.9 else CoolMsg[1]
	
	Globals.save_game("user://config.conf",{
	"MusicVolume":Globals.MVol,
	"SoundEffectVolume":Globals.SEVol
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
