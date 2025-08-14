extends AnimatableBody2D

var BodyIn := false

var MoveDelta : Vector2 

var PrevPos : Vector2 

var PNode

func _physics_process(delta):
	if PrevPos:
		MoveDelta = global_position - PrevPos
	else:
		MoveDelta = Vector2.ZERO
	PrevPos = global_position
	MoveAlong()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		BodyIn = true
		if !PNode:
			PNode = body

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		BodyIn = false

func MoveAlong():
	if PNode and BodyIn and !PNode.Immortalix:
		PNode.global_position += MoveDelta
