extends CanvasLayer

@onready var BeerBtn = $Collectibles/HBoxContainer/BottleActivar
@onready var MilkBtn = $Collectibles/HBoxContainer/MilkActivar

func _ready():
	SignalBus.GetItem.connect(_on_get_item)
	if Globals.SpecialItem:
		$wife.visible = true

func _process(delta):
	if Input.is_action_just_pressed("Pause") and !Globals.DisableAction:
		BeerBtn.button_pressed = Globals.EffectActive[Globals.Beer]
		MilkBtn.button_pressed = Globals.EffectActive[Globals.Milk]
		visible = !visible
		get_tree().paused = !get_tree().paused
		BeerBtn.disabled = !Globals.Items[Globals.Passive][Globals.Beer]
		MilkBtn.disabled = !Globals.Items[Globals.Passive][Globals.Milk]

func _on_exit_button_pressed():
	get_tree().quit()

func _on_back_button_pressed():
	visible = false
	get_tree().paused = false

func _on_bottle_activar_pressed():
	if Globals.Items[Globals.Passive][Globals.Beer]:
		Globals.EffectActive[Globals.Beer] = !Globals.EffectActive[Globals.Beer]
		SignalBus.emit_signal("ScreenShaderChange",Globals.EffectActive[Globals.Beer],Globals.Beer)

func _on_milk_activar_pressed():
	if Globals.Items[Globals.Passive][Globals.Milk]:
		Globals.EffectActive[Globals.Milk] = !Globals.EffectActive[Globals.Milk]
		SignalBus.emit_signal("ScreenShaderChange",Globals.EffectActive[Globals.Milk],Globals.Milk)

func _on_wife_pressed():
	if $Godhelpme.playing == false:
		$Godhelpme.play()

func _on_get_item(type):
	if type == "wife":
		$wife.visible = true


func _on_texture_button_pressed():
	$SettingsMenu.visible = true
