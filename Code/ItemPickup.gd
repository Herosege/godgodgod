extends Node2D

enum {Passive,Weapon}
enum {Axe,Gun,Shotgun}
enum {Beer,Milk}

@export_enum("Passive","Weapon") var ItemType : int
@export_enum("Beer","Milk") var Passives : int
@export_enum("Axe","Gun","Shotgun") var Weapons : int

var TempType

func _ready():
	
	TempType = Passives
	if ItemType == Weapon:
		TempType = Weapons
	
	if Globals.Items[ItemType][TempType]:
		queue_free()
	
	if ItemType == Passive:
		match TempType:
			Beer:
				$ItemAnim.play("Bottle")
			Milk:
				$ItemAnim.play("Milk")
	else:
		match TempType:
			Axe:
				$ItemAnim.play("Axe")

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		Globals.Items[ItemType][TempType] = true
		if ItemType == Weapon and Weapons == Axe:
			SignalBus.emit_signal("SetHudMessage","Press x to swing axe",1)
		queue_free()
