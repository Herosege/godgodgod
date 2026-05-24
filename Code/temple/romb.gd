extends Area2D

@export_multiline var Message : String

var ID : String

func _enter_tree():
	ID = get_path()
	if STEvents.OneTimeJammers.has(ID):
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		STEvents.RombsGotten.append(ID)
		Globals.Rombs = STEvents.RombsGotten.size()
		SignalBus.PlaySoundEffect.emit(Globals.SEID.RombGet)
		SignalBus.SetHudMessage.emit("ROMB FOUND\n"+Message,1,5.0)
		
		queue_free()
