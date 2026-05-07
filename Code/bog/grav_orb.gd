extends Node2D

var Available = true

const LauchVel = 500.0

const AddVel = -20

const MAX_FRAMES := 4

@onready var PNode = get_tree().get_first_node_in_group("player")

func _ready():
	pass

func _process(delta):
	$AnimatedSprite2D.frame = GAnimTimer.GlobalAnimFrame%MAX_FRAMES

#func _on_area_2d_area_entered(area):
	#if area.is_in_group("damage") and Available:
		#PNode.AdditVel.x -= LauchVel * PNode.LastDir
		#Available = false
		#$Timer.start()
		#$AnimatedSprite2D.play("not_avi")


func _on_timer_timeout():
	Available = true
	$AnimatedSprite2D.animation = "default"


func RESET():
	Available = true
	$AnimatedSprite2D.play("default")


func _on_body_entered(body):
	if body.is_in_group("player") and Available:
		#body.AdditVel.x += LauchVel * body.LastDir
		body.ActivarReduceGravity()
		#if body.velocity.y > 0.0:
			#body.velocity.y = AddVel
		#else:
			#body.velocity.y += AddVel
		Available = false
		$Timer.start()
		$AnimatedSprite2D.animation = "not_avi"
