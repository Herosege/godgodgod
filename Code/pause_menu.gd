extends CanvasLayer

@onready var BeerBtn = $Collectibles/VBoxContainer/HBoxContainer/BottleActivar
@onready var MilkShw = $Collectibles/VBoxContainer/HBoxContainer/TextureRect
@onready var WaterShw = $Collectibles/VBoxContainer/HBoxContainer2/WaterActivar

@onready var Pause = get_tree().get_first_node_in_group("PAUSE")

func _ready():
	SignalBus.GetItem.connect(_on_get_item)
	SignalBus.SettingChanged.connect(OnSettingsChanged)
	if Globals.KeybindList:
		MilkShw.tooltip_text = "Mleko\nAllows you to move slowly with {0}\n(Always active)".format([Globals.KeybindList["Slowdown"][1].trim_suffix(" (Physical)")])
	$wife.visible = Globals.SpecialItem
	$DeathAmt.text = str(int(Globals.NumDeaths))
	MilkShw.visible = Globals.Items[Globals.Passive][Globals.Milk]
	BeerBtn.visible = Globals.Items[Globals.Passive][Globals.Beer]
	WaterShw.visible = Globals.Items[Globals.Passive][Globals.Water]

func _process(delta):
	if Input.is_action_just_pressed("Pause") and !Globals.DisableAction:
		$DeathAmt.text = str(int(Globals.NumDeaths))
		Globals.MenuPaused = !Globals.MenuPaused
		BeerBtn.button_pressed = Globals.EffectActive[Globals.Beer]
		visible = !visible
		get_tree().paused = !get_tree().paused
		
		MilkShw.visible = Globals.Items[Globals.Passive][Globals.Milk]
		BeerBtn.visible = Globals.Items[Globals.Passive][Globals.Beer]
		WaterShw.visible = Globals.Items[Globals.Passive][Globals.Water]
		$wife.visible = Globals.SpecialItem
		
		BeerBtn.disabled = !Globals.Items[Globals.Passive][Globals.Beer]

func _on_exit_button_pressed():
	get_tree().quit()

func _on_back_button_pressed():
	Globals.MenuPaused = false
	visible = false
	get_tree().paused = false

func _on_bottle_activar_pressed():
	if Globals.Items[Globals.Passive][Globals.Beer]:
		Globals.EffectActive[Globals.Beer] = !Globals.EffectActive[Globals.Beer]
		SignalBus.emit_signal("ScreenShaderChange",Globals.EffectActive[Globals.Beer],Globals.Beer)

#func _on_milk_activar_pressed():
	#if Globals.Items[Globals.Passive][Globals.Milk]:
		#Globals.EffectActive[Globals.Milk] = !Globals.EffectActive[Globals.Milk]
		#SignalBus.emit_signal("ScreenShaderChange",Globals.EffectActive[Globals.Milk],Globals.Milk)

func _on_wife_pressed():
	if $Godhelpme.playing == false:
		$Godhelpme.play()

func _on_get_item(type):
	if Globals.SpecialItem:
		$wife.visible = true

func _on_texture_button_pressed():
	$SettingsMenu.visible = true

func OnSettingsChanged():
	MilkShw.tooltip_text = "Mleko\nAllows you to move slowly with {0}\n(Always active)".format([Globals.KeybindList["Slowdown"][1].trim_suffix(" (Physical)")])


func _on_water_activar_pressed():
	if Globals.Items[Globals.Passive][Globals.Water]:
		var POSTO = Vector2(210,365)
		Globals.LoadScene(Globals.AreaScenes[8])
		Globals.PosSetTravel = POSTO
		Globals.SavedPos[0] = POSTO
		Globals.SavedPos[1] = 8
		Globals.MenuPaused = false
		visible = false
		get_tree().paused = false
		Pause.ResetStuff()
