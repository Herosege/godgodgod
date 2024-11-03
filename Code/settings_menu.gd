extends Control

@onready var VSyncBut = $Settings/MarginContainer/VBoxContainer/HBoxContainer3/VSyncButton
@onready var AVSl = $Settings/MarginContainer/VBoxContainer/HBoxContainer5/AVSl
@onready var SEVSl = $Settings/MarginContainer/VBoxContainer/HBoxContainer6/AVSl2

func _ready():
	VSyncBut.button_pressed = Globals.VSync
	AVSl.value = Globals.MVol
	SEVSl.value = Globals.SEVol

func _on_exit_button_pressed():
	Globals.save_game("user://config.conf",{
	"VSync":Globals.VSync,
	"MusicVolume":Globals.MVol,
	"SoundEffectVolume":Globals.SEVol
	})
	visible = false

func _on_v_sync_button_toggled(toggled_on):
	Globals.VSync = toggled_on

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
