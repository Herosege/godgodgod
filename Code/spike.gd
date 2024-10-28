extends Area2D

@export var SType = 0
@export var MoveGroup = 0

var Anims = ["Flower","Spike","BSpike","Soul","BridgeSpike"]

@onready var PrevPos = position

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.animation = Anims[SType]
	if MoveGroup:
		add_to_group("group" + str(MoveGroup))
	match MoveGroup:
		1:
			start_tween(Vector2(0.0,28.0),0.33)
		2:
			start_tween(Vector2(0.0,-28.0),0.33)

func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("player"):
		SignalBus.emit_signal("Death")

func start_tween(Offset : Vector2,Speed : float):
	var tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property(self, "position", PrevPos + Offset, Speed)
	tween.tween_property(self, "position", PrevPos, Speed)
