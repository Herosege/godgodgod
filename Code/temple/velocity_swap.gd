extends Area2D

var Available = true

@onready var PNode = get_tree().get_first_node_in_group("player")

func _ready(): 
	pass

func _on_area_entered(area):
	if area.is_in_group("damage") and Available:
		Available = false
		$Timer.start()
		$AnimatedSprite2D.play("not_avi")
		if PNode:
			PNode.AdditVel = Vector2(PNode.AdditVel.y,-abs(PNode.AdditVel.x))
			PNode.AdditVel += Vector2(PNode.velocity.y*2.0,-abs(PNode.MovementVel.x)*3.0)

func RESET():
	Available = true
	$AnimatedSprite2D.play("default")

func _on_timer_timeout():
	Available = true
	$AnimatedSprite2D.play("default")
