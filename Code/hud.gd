extends CanvasLayer

func _ready():
	SignalBus.Death.connect(_on_die)
	SignalBus.ResetPos.connect(ResetPosition)
	SignalBus.HudMessage.connect(SetHudMessage)

func _on_die():
	$DeadHint.visible = true

func ResetPosition():
	$DeadHint.visible = false

func SetHudMessage(message):
	$Message.text = message
	await get_tree().create_timer(2.0).timeout
	$Message.text = ""
