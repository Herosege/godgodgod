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
			EventVar = 1
			if EventVar == 1:
				$Label.text = Texts["cursegod1"]
				SignalBus.emit_signal("SetHudMessage","",0)
				if !Globals.SpecialItem:
					$"../Secrets/Wife".position = Vector2(-2000,300)

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
				if EventVar == 0:
					$Label.text = Texts["cursegod"]
				awaitres = true
				if EventVar != 2:
					SignalBus.emit_signal("SetHudMessage","Press space to continue",0)
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
	"cursegod":"Hello little being
	
	I don't know how you managed to get here, but please get out
	
	You see I am a curse, a synthetic being and I've sealed myself here
	Away from everything and everyone, for I am about to meet an awful fate
	
	I will transform into a red thinkless living mass consuming everything around me
	
	I've seen other curses turn into that and nothing I have done helped anyone
	
	I think that's just our fate",
	
	
	
	"cursegod1":"Well since you are here
	I have this weird artifact
	
	It seems powerful so maybe you will find a use for it",
	#
	
	#"I am the one overseeing this realm
	#I am a curse - a synthetic creature
	#Both this world and me and everything included were created by
	#Hania, the great creator "
	
	"onen":"Hey Othenson 
It seems some nasty disease like creature has struck our bridge
and it seems like it's spreading
But don't worry, if you find it's core you could destroy it

Also if you kill these floating things you will
get their strength and you will regain a jump",
	
	#
	
	"henryk":"HI YOU FREAKY LIITLE THING, MY NAME IS HENRYK
	
	YOU SEE THERE IS A SMALL PROBLEM REGARDING THE ENTRANCE TO
	THAT TREE OVER THERE, IT IS BLOCKED BY THIS GODDD DAMNED SHIT TWIG PILE
	
	THIS WOULD NOT BE SO BAD BUT I DO NOT POSSESS ANY SHARP OBJECTS
	TO CUT THIS STUFF UP
	
	FORTUNATELY THERE IS AN AXE IN THE CURSE WORLD AND THE GATE
	TO THAT PLACE IS CLOSE BY SO GO GET IT
	
	BE QUICK BECAUSE THERE IS SOME CANCEROUS STUFF GROWING NEAR
	THAT I MUST GET RID OF =)"
}
