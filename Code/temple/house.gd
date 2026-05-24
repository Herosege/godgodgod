extends Node2D

@onready var PNode = get_tree().get_first_node_in_group("player")

func _ready():
	PNode.global_position = Vector2(640,480)/2
