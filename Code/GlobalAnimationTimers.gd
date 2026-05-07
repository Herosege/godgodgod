extends Node

const GLOBAL_ANIM_FPS := 2.0
const GLOBAL_ANIM_TIME_BETWEEN := 1.0/GLOBAL_ANIM_FPS
var GlobalAnimFrame := 0

var AnimTimer := 0.0

func _physics_process(delta):
	AnimTimer += delta
	if AnimTimer >= GLOBAL_ANIM_TIME_BETWEEN:
		AnimTimer -= GLOBAL_ANIM_TIME_BETWEEN
		GlobalAnimFrame+=1
		GlobalAnimFrame%=20
