extends Area2D

@onready var Sprite = $AnimatedSprite2D

func _ready():
	Sprite.scale = Vector2(1.0,1.0)
	Sprite.modulate = Color(1.0,1.0,1.0,1.0)

var Bod

var PlayerIn := false

func _physics_process(delta):
	if PlayerIn and Bod:
		ActivarJumpOrb(Bod)

func ActivarJumpOrb(body):
	if body.JumpAmount == 0:
		body.JumpAmount = 1
		if body.CanBufferJump:
			body.Jump()
		Sprite.scale = Vector2(0.5,0.5)
		Sprite.modulate = Color(0.0,0.0,0.0,0.9)
		$CollisionShape2D.call_deferred("set_disabled",true)
		$Timer.start()

func _on_timer_timeout():
	Sprite.scale = Vector2(1.0,1.0)
	Sprite.modulate = Color(1.0,1.0,1.0,1.0)
	$CollisionShape2D.call_deferred("set_disabled",false)

func RESET():
	$Timer.stop()
	Sprite.scale = Vector2(1.0,1.0)
	Sprite.modulate = Color(1.0,1.0,1.0,1.0)
	$CollisionShape2D.call_deferred("set_disabled",false)

func _on_body_entered(body):
	if body.is_in_group("player"):
		#ActivarJumpOrb(body)
		Bod = body
		PlayerIn = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		Bod = body
		PlayerIn = false
