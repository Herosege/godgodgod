extends Node2D

enum {Passive,Weapon}
enum {Axe,Shotgun}
enum {Beer,Milk,Water}

@export_enum("Passive","Weapon") var ItemType : int
@export_enum("Beer","Milk","Water") var Passives : int
@export_enum("Axe","Shotgun") var Weapons : int

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
			Water:
				$ItemAnim.play("Water")
	else:
		match TempType:
			Axe:
				$ItemAnim.play("Axe")
			Shotgun:
				$ItemAnim.play("Shotgun")

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		Globals.Items[ItemType][TempType] = true
		if ItemType == Weapon and Weapons == Axe:
			var Message = "Press {0} to swing axe".format([Globals.KeybindList["AttackInp"][1].trim_suffix(" (Physical)")])
			SignalBus.emit_signal("SetHudMessage",Message,1)
		if ItemType == Weapon and Weapons == Shotgun:
			var Message = "Press {0} to use the shotgun".format([Globals.KeybindList["ShotgunInp"][1].trim_suffix(" (Physical)")])
			SignalBus.emit_signal("SetHudMessage",Message,1)
		if ItemType == Passive and Passives == Milk:
			SignalBus.emit_signal("SetHudMessage","Use items in the Esc menu",1)
		queue_free()
