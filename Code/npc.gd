extends Node2D
class_name npc


@export_enum("henryk","someone","curse","ONEN") var type

enum {henryk,someone,curse,ONEN}

var awaitres = false

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
				ONEN:
					if $Timer.is_stopped():
						$Timer.start(1)
						Globals.stoptime = true

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
				$Label.text = Globals.read_file("res://Misc/dialogues/henryk.txt")
				
			someone:
				$Label.visible = true
				$Label.text = Globals.read_file("res://Misc/dialogues/onen.txt")
			curse:
				$Panel.visible = true
				$Label.visible = true
				$Label.text = Globals.read_file("res://Misc/dialogues/cursegod.txt")
				if !Globals.SpecialItem:
					Globals.SpecialItem = true
					SignalBus.emit_signal("GetItem","wife")
			ONEN:
				$Label.visible = true
				awaitres = true

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
				$Panel.visible = false
				$Label.visible = false
			ONEN:
				$Label.visible = false

func animatetext():
	pass

func _on_timer_timeout():
	get_tree().call_deferred("change_scene_to_file","res://Scenes/epilogue.tscn")
