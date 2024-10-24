extends Area2D

var CanSave = false
@onready var SHint = get_tree().get_first_node_in_group("SHint")
@onready var SLabel = get_tree().get_first_node_in_group("SLabel")

func _ready():
	pass

func _process(delta):
	if SLabel.modulate.a:
		SLabel.modulate.a = lerp(SLabel.modulate.a,0.0,delta*6)
	if CanSave and Input.is_action_just_pressed("SaveInp") and $SaveCD.is_stopped():
		Globals.SavedPos[0] = global_position
		Globals.SavedPos[1] = Globals.CArea
		$SaveCD.start()
		$SaveSE.play()
		SLabel.modulate.a = 1.0
		SignalBus.emit_signal("Save",0)

func _on_body_entered(body):
	if body.is_in_group("player"):
		CanSave = true
		SHint.visible = true
		SLabel.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		CanSave = false
		SHint.visible = false
