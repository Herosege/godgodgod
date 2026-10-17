extends CanvasLayer

@onready var BeerBtn = $Collectibles/VBoxContainer/HBoxContainer/BottleActivar
@onready var MilkShw = $Collectibles/VBoxContainer/HBoxContainer/TextureRect
@onready var WaterShw = $Collectibles/VBoxContainer/HBoxContainer2/WaterActivar
@onready var KeyShw = $Collectibles/VBoxContainer/HBoxContainer2/TextureRect2

@onready var Pause = get_tree().get_first_node_in_group("PAUSE")

var BGImageNormal = load("res://Assets/painting1.png")
var BGImageHouse = load("res://Assets/temple/pause_housebg_1.png")

func _ready():
	visible = false
	SignalBus.GetItem.connect(_on_get_item)
	SignalBus.SettingChanged.connect(OnSettingsChanged)
	SignalBus.GetInHouse.connect(OnGetInHouse)
	StartStuff()

func _process(delta):
	if Input.is_action_just_pressed("Pause") and !Globals.DisableAction:
		visible = !visible
		get_tree().paused = !get_tree().paused
		if !Globals.InHouse:
			Globals.MenuPaused = !Globals.MenuPaused
			
			$DeathAmt.text = str(int(Globals.NumDeaths))
			
			BeerBtn.button_pressed = Globals.EffectActive[Globals.Beer]
			KeyShw.visible = Globals.Endings[Globals.End.EndingTravel]
			
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
	MilkShw.tooltip_text = "Mleko\nAllows you to move slowly with {0}\non ground and along walls\n(Always active)".format([Globals.KeybindList["Slowdown"][1].trim_suffix(" (Physical)")])


func _on_water_activar_pressed():
	if Globals.Items[Globals.Passive][Globals.Water]:
		var POSTO = Vector2(210,365)
		Globals.LoadScene(Globals.AreaScenes[8])
		Globals.PosSetTravel = POSTO
		#Globals.SavedPos[0] = POSTO
		#Globals.SavedPos[1] = 8
		Globals.MenuPaused = false
		visible = false
		get_tree().paused = false
		Pause.ResetStuff()

func OnGetInHouse(Entering):
	if Entering:
		$Label.visible = false
		$Background.texture = BGImageHouse
		$wife.visible = false
		$DeathAmt.text = ""
		MilkShw.visible = false
		BeerBtn.visible = false
		WaterShw.visible = false
		$TextureRect.visible = false
	else:
		StartStuff()

func StartStuff():
	$Label.visible = true
	$TextureRect.visible = true
	$Background.texture = BGImageNormal
	if Globals.KeybindList:
		MilkShw.tooltip_text = "Mleko\nAllows you to move slowly with {0}\non ground and along walls\n(Always active)".format([Globals.KeybindList["Slowdown"][1].trim_suffix(" (Physical)")])
	$wife.visible = Globals.SpecialItem
	$DeathAmt.text = str(int(Globals.NumDeaths))
	KeyShw.visible = Globals.Endings[Globals.End.EndingTravel]
	MilkShw.visible = Globals.Items[Globals.Passive][Globals.Milk]
	BeerBtn.visible = Globals.Items[Globals.Passive][Globals.Beer]
	WaterShw.visible = Globals.Items[Globals.Passive][Globals.Water]
