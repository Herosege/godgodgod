@tool
extends Node2D

@export var Activ : bool = false

var FImg = load("res://Assets/flower1.png")

var VPort = Vector2(640,480)

var Bsize = 20


func _ready():
	visible = false
	if Activ:
		for x in range(-Bsize,Bsize):
			for y in range(-Bsize,Bsize):
				var Spr = Sprite2D.new()
				Spr.texture = FImg
				Spr.global_position = Vector2(x*VPort.x,y*VPort.y)
				add_child(Spr)
