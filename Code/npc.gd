extends Node2D
class_name npc


@export_enum("henryk","henrykbridge","someone","curse","ONEN") var type

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
			if EventVar == 0:
				$Label.text = Texts["cursegod1"]
			if EventVar == 1:
				$Label.text = Texts["cursegod2"]
				SignalBus.emit_signal("SetHudMessage","",0)
				if !Globals.SpecialItem:
					$"../Secrets/Wife".position = Vector2(-2000,300)
			EventVar += 1
			EventVar = min(EventVar,2)

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
	"cursegod":"Hi little being
	
	We are beings overseeing this realm, named curses 
	
	You see something awful has happened recently 
	
	One of us, they have been entangled in something in thier mind
	These thoughts consumed them and out of it
	The Rotten Curse came into existence
	A powerful being that conquests and consumes everything
	
	It is no longer here and spread out to your realm
	
	We must do something about it",
	
	#
	
	"cursegod1":"There is a worm named henryk
	They are already hunting the fragments of The Rotten Curse
	
	I have entrusted them with many powerful spells
	But they definitely do not have the will
	To actually destroy the root of it
	
	You on the other hand have the will
	You managed to get past my trial 
	And you figured out how to get here",
	
	"cursegod2":"You have what it takes
	
	Here is the ultimate great weapon of absolute annihilation
	Called The Wife
	It will kill them, definitely
	
	Head to the east
	Past the bridge, past the tower
	
	That is where root of Rotten Curse resides 
	
	Rest is up to you, Good luck!",
	#
	
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
