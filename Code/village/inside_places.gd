extends Node2D

func _ready():
	Globals.CArea = 3
	SignalBus.ScreenShaderChange.connect(_on_EffectChange)
	if Globals.EffectActive[Globals.Beer]:
		$Tavern/Stuff/Secret/Beergate/CollisionShape2D.set_deferred("disabled",true)
		$Tavern/Stuff/Secret/Beergate.visible = false

func _on_EffectChange(value,type):
	if value == true and type == Globals.Beer:
		$Tavern/Stuff/Secret/Beergate/CollisionShape2D.set_deferred("disabled",true)
		$Tavern/Stuff/Secret/Beergate.visible = false
	
	if value == false and type == Globals.Beer:
		$Tavern/Stuff/Secret/Beergate/CollisionShape2D.set_deferred("disabled",false)
		$Tavern/Stuff/Secret/Beergate.visible = true
