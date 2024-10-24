extends Node2D

@onready var PlayerNode = get_tree().get_first_node_in_group("player")

func _process(delta):
	if Input.is_action_just_pressed("ResetInp"):
		get_tree().paused = false
		
		Globals.DisableAction = false
		
		SignalBus.emit_signal("ResetPos")
		if PlayerNode:
			PlayerNode.get_node("AnimatedSprite2D").visible = true
		
		if Globals.SavedPos[1] != Globals.CArea:
			get_tree().change_scene_to_file(Globals.AreaScenes[Globals.SavedPos[1]])
		else:
			get_tree().reload_current_scene()
