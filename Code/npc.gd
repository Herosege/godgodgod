extends Node2D
class_name npc


@export_enum("henryk","someone","curse","ONEN") var type

enum {henryk,someone,curse,ONEN}

var awaitres = false

var EventVar = 0

func _ready():
	match type:
		someone:
			$AnimatedSprite2D.animation = "default"
		ONEN:
			$AnimatedSprite2D.animation = "default"
		curse:
			$AnimatedSprite2D.animation = "curse"

func _process(delta):
	if awaitres:
		if Input.is_action_just_pressed("Confirm"):
			match type:
				curse:
					$Label.text = Texts["cursegod1"]
					SignalBus.emit_signal("SetHudMessage","",0)
					if !Globals.SpecialItem:
						Globals.SpecialItem = true
						SignalBus.emit_signal("GetItem","wife")
						SignalBus.emit_signal("Save",0)

func _on_area_2d_area_entered(area):
	if area.is_in_group("damage") and type == henryk:
		pass

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		match type:
			henryk:
				$AnimatedSprite2D.play("default")
				$AudioStreamPlayer.playing = true
				$Label.visible = true
				$Label.text = Texts["henryk"]
				
			someone:
				$Label.visible = true
				$Label.text = Texts["onen"]
			curse:
				$Label.visible = true
				
				awaitres = true
				SignalBus.emit_signal("SetHudMessage","Press space to continue",0)
				$Label.text = Texts["cursegod"]
			ONEN:
				$Label.visible = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		match type:
			henryk:
				$AnimatedSprite2D.stop()
				$AnimatedSprite2D.frame = 0
				$AudioStreamPlayer.playing = false
				$Label.visible = false
			someone:
				$Label.visible = false
			curse:
				SignalBus.emit_signal("SetHudMessage","",0)
				$Label.visible = false
				awaitres = false
			ONEN:
				$Label.visible = false

func animatetext():
	pass

func _on_timer_timeout():
	get_tree().call_deferred("change_scene_to_file","res://Scenes/epilogue.tscn")

var Texts = {
	"cursegod":"Hi little being
	
	As you can see this place is devoid of any life
	
	I am currently the only curse in this region as others have escaped
	because of the rotten curse that has appeared nearby
	
	Unfortunately for you it managed to get to your world 
	even though it can't travel with gates
	
	You look like someone that has suffered a lot so you may have a will to
	do something about it",
	
	#
	
	"cursegod1":"Huh, there seems to be a problem 
	I can't open the gate to the bridge
	
	Oh well, that's unfortunate, you will have to find another way there
	
	Have a \"wife\" for your efforts though
	
	",
	
	#
	
	"onen":"hey othenson

There is a new bar in the village to the east of here across the bridge
it would be cool if we went there

Unfortunately the bridge collapsed and the gate is broken or something because it's not opening, but I think that won't stop you since you are basically immortal

So good luck and see you there!",
	
	#
	
	"henryk":"HI YOU FREAKY LIITLE THING, MY NAME IS HENRYK
	
	YOU SEE THERE IS A SMALL PROBLEM REGARDING THE ENTRANCE TO
	THAT TREE OVER THERE, IT IS BLOCKED BY THIS GODDD DAMNED SHIT TWIG PILE
	
	THIS WOULD NOT BE SO BAD BUT I DO NOT POSSESS ANY SHARP OBJECTS
	TO CUT THIS STUFF UP
	
	FORTUNATELY THERE IS AN AXE IN THE CURSE WORLD AND THE GATE
	TO THAT PLACE IS CLOSE BY SO GO GET IT
	
	BE QUICK BECAUSE THERE IS A CANCER GROWING NEAR
	THAT I MUST GET RID OF =)"
}
