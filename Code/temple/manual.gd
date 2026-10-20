extends Control

var Activar := false

func _ready():
	visible = false

func _on_man_but_pressed():
	Activar = !Activar
	visible = Activar
