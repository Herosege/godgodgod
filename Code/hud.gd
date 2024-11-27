extends CanvasLayer

func _ready():
	SignalBus.Death.connect(_on_die)
	SignalBus.ResetPos.connect(ResetPosition)
	SignalBus.SetHudMessage.connect(SetHudMessage)

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
	
