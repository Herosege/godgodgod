extends Area2D

var Available = true

const MAX_FRAMES = 2

@export var StackMomentum := false

func _ready():
	if StackMomentum:
		modulate = Color.hex(0xffa361ff)

func _process(delta):
	$AnimatedSprite2D.frame = GAnimTimer.GlobalAnimFrame%MAX_FRAMES

func _on_area_entered(area):
	if area.is_in_group("damage") and Available:
		Available = false
		$Timer.start()
		$AnimatedSprite2D.play("not_avi")
		SignalBus.emit_signal("FOrbUse",StackMomentum)

func RESET():
	Available = true
	$AnimatedSprite2D.animation = "default"

func _on_timer_timeout():
	Available = true
	$AnimatedSprite2D.animation = "default"
