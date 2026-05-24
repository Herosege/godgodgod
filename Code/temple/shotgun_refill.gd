extends Area2D

var Available = true

@onready var SNode = get_tree().get_first_node_in_group("shotgun")
@onready var PNode = get_tree().get_first_node_in_group("player")

const MAX_FRAMES := 2

func _process(delta):
	$AnimatedSprite2D.frame = GAnimTimer.GlobalAnimFrame%MAX_FRAMES

func _ready(): 
	if SNode:
		SNode = SNode.get_parent()

const ExVel := -100.0

func _on_area_entered(area):
	if area.is_in_group("damage") and Available and SNode:
		Available = false
		if PNode.velocity.y > 0.0:
			PNode.velocity.y = ExVel
		else:
			PNode.velocity.y += ExVel
		
		SNode.StopCD()
		SNode.OneTimeAmmo = true
		
		$Timer.start()
		$AnimatedSprite2D.play("not_avi")

func RESET():
	Available = true
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D.frame = 0

func _on_timer_timeout():
	Available = true
	$AnimatedSprite2D.play("default")
