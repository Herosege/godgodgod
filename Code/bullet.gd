extends Area2D

var Towards : Vector2
var Speed = 350.0

var Velocity : Vector2

func _ready():
	look_at(Towards)
	rotation += PI/2
	Velocity = (Towards - global_position).normalized()

func _process(delta):
	global_position += Velocity * Speed * delta


func _on_body_entered(body):
	if body.is_in_group("player"):
		SignalBus.emit_signal("Death")
		

func _on_timer_timeout():
	queue_free()
