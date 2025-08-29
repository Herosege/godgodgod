extends Node2D

var PNode

func _ready():
	$AudioStreamPlayer2D.play()

func _process(delta):
	PNode = get_tree().get_first_node_in_group("player")
	if PNode:
		global_position = global_position.move_toward(PNode.global_position,(delta*(PNode.velocity.length()*3.5))+delta*33)

func RESET():
	queue_free()
