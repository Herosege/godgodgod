extends CanvasLayer

@onready var ShotgunTimer = $ShotGunTimer

func _ready():
	if Globals.KeybindList:
		$DeadHint.text = "press {0} to restart".format([Globals.KeybindList["ResetInp"][1]])
	SignalBus.SettingChanged.connect(OnSettingChange)
	$Timer.visible = Globals.TimerOn
	ShotgunTimer.visible = false
	SignalBus.Death.connect(_on_die)
	SignalBus.Save.connect(_on_Save)
	SignalBus.ResetPos.connect(ResetPosition)
	SignalBus.SetHudMessage.connect(SetHudMessage)
	SignalBus.ShotgunTimerHudUpdate.connect(ShotgunTimerHudUpdate)
	SignalBus.SettingChanged.connect(OnSettingChanged)

func _process(delta):
	if Globals.TimerOn:
		var Times = Globals.sec_to_time(Globals.SaveTime)
		var StrSec = str(Times[0]) if floor(Times[0]/10.0) > 0 else "0"+str(Times[0])
		var StrMin = str(Times[1]) if floor(Times[1]/10.0) > 0 else "0"+str(Times[1])
		$Timer.text =  str(Times[2]) + ":" + StrMin + ":" + StrSec

func _on_die():
	$DeadHint.visible = true

func ResetPosition():
	$DeadHint.visible = false

func SetHudMessage(message,type):
	match type:
		0:
			$MessageDown.text = message
		1:
			$Message.text = message
			await get_tree().create_timer(2.0).timeout
			$Message.text = ""

func ShotgunTimerHudUpdate(TimeLeft,TimeMax):
	var Value = (1 - (TimeLeft / TimeMax)) * ShotgunTimer.max_value
	ShotgunTimer.visible = true
	ShotgunTimer.value = Value

func _on_shot_gun_timer_value_changed(value):
	if value >= ShotgunTimer.max_value-2:
		ShotgunTimer.visible = false

func RESET():
	ShotgunTimer.visible = false

func OnSettingChange():
	$Timer.visible = Globals.TimerOn

func _on_Save(type):
	$SavedAnim.play("Saved")

func OnSettingChanged():
	$DeadHint.text = "press {0} to restart".format([Globals.KeybindList["ResetInp"][1]])
