extends Area2D

var Towards : Vector2
var Speed := 320.0

var AccelDir := Vector2.ZERO
var AccelSpeed := 0.0

var Velocity : Vector2
var Acceleration : Vector2

var DeleteTime := 4.0

func _ready():
	$Timer.start(DeleteTime)
	look_at(Towards)
	rotation += PI/2
	Velocity = Towards.normalized()

func _physics_process(delta):
	global_position += Velocity * Speed * delta
	Velocity += (AccelDir * AccelSpeed * delta)/Speed


func _on_body_entered(body):
	if body.is_in_group("player"):
		pass
		

func _on_timer_timeout():
	queue_free()

func RESET():
	queue_free()
