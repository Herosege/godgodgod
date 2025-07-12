extends Area2D

@export var SType = 0

var Anims = ["Flower","Spike","BSpike","Soul","BridgeSpike"]

@onready var PrevPos = position

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.animation = Anims[SType]

func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("player"):
		pass
		#SignalBus.emit_signal("Death")
