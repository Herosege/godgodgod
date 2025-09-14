extends CanvasLayer

@onready var ShotgunTimer = $ShotGunTimer

func _ready():
	ShotgunTimer.visible = false
	SignalBus.Death.connect(_on_die)
	SignalBus.ResetPos.connect(ResetPosition)
	SignalBus.SetHudMessage.connect(SetHudMessage)
	SignalBus.ShotgunTimerHudUpdate.connect(ShotgunTimerHudUpdate)

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
	if value >= ShotgunTimer.max_value:
		ShotgunTimer.visible = false

func RESET():
	ShotgunTimer.visible = false
