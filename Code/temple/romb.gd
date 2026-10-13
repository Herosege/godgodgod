extends Area2D

@export_multiline var Message : String
@export var RombType : STEvents.RombLoc

var ID : String

func _enter_tree():
	#ID = get_path()
	#if STEvents.RombsGotten.has(ID):
		#queue_free()
	if STEvents.RombsGotten[RombType]:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		STEvents.RombsGotten[RombType] = true
		#STEvents.RombsGotten.append(ID)
		Globals.Rombs += 1
		SignalBus.PlaySoundEffect.emit(Globals.SEID.RombGet)
		SignalBus.SetHudMessage.emit("ROMB FOUND\n"+Message,1,5.0)
		if STEvents.GetRombCAmnt() == STEvents.RombsGotten.size():
			STEvents.Achievements[STEvents.ACHIEVEMENT.ALL_ROMBS].Achieved = true
		Globals.SavePerma()
		queue_free()
