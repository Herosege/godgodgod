extends Area2D

enum {Gate,Rings,NoiseT,GateTree}
@export_enum("Gate","Rings","Noise","GateTree") var GateType 
@export_enum("DoomedExistance","CurseWorld") var WhereTo 
@export var Coords = Vector2(0,0)

func _ready():
	match GateType:
		Gate:
			$AnimatedSprite2D.play("gate")
			$CollisionShape2D.shape = RectangleShape2D.new()
			$CollisionShape2D.shape.size = Vector2(64,128)
		Rings:
			$AnimatedSprite2D.play("rings")
			$CollisionShape2D.shape = RectangleShape2D.new()
			$CollisionShape2D.shape.size = Vector2(32,32)
		NoiseT:
			$AnimatedSprite2D.play("noise")
			$CollisionShape2D.shape = RectangleShape2D.new()
			$CollisionShape2D.shape.size = Vector2(32,32)
		GateTree:
			$AnimatedSprite2D.play("gatetree")
			$CollisionShape2D.shape = RectangleShape2D.new()
			$CollisionShape2D.shape.size = Vector2(32,32)

func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("player"):
		get_tree().call_deferred("change_scene_to_file",Globals.AreaScenes[WhereTo])
		Globals.SavedPos[0] = Coords
		Globals.SavedPos[1] = WhereTo
		body.position = Coords
