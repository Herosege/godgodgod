extends Node2D

@onready var PlayerNode = get_tree().get_first_node_in_group("player")

func _ready():
	get_tree().paused = false

func _process(delta):
	if Input.is_action_just_pressed("ResetInp") and !Globals.MenuPaused:
		ResetStuff()

func ResetStuff():
	SignalBus.emit_signal("ResetPos")
	await get_tree().physics_frame
	SignalBus.emit_signal("ResetPos")
	Globals.DisableAction = false
	get_tree().paused = false
	if PlayerNode:
		PlayerNode.get_node("AnimatedSprite2D").visible = true
	
	if Globals.SavedPos[1] != Globals.CArea:
		Globals.LoadScene(Globals.AreaScenes[Globals.SavedPos[1]])
	else:
		get_tree().call_group("RESET","RESET")
	PlayerNode.Immortalix = true
