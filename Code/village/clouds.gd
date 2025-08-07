@tool
extends Node2D

const INSTANCE_COUNT := 345

@onready var MMeshInst = $MultiMeshInstance2D 
@onready var MMeshInst2 = $MultiMeshInstance2D2
@onready var MMeshInst3 = $MultiMeshInstance2D3


func _ready():
	var CloudsMMeshes = get_children()
	
	for j in CloudsMMeshes.size():
		CloudsMMeshes[j].multimesh.instance_count = INSTANCE_COUNT
		for i in INSTANCE_COUNT:
			var RPos = Vector2(int(i/2)*20*(0.9+(randf()/10.0)),randf()*(-50)) + Vector2(0,-520.0)
			var RScale = Vector2(1.0,1.0)*(0.83+randf()/3.0)
			CloudsMMeshes[j].multimesh.set_instance_transform_2d(i,Transform2D(0.0,RScale,0.0,RPos))
			

const CLOUD_DISTANCE = 3400.0

func _process(delta):
	var CloudsMMeshes = get_children()
	for j in CloudsMMeshes.size():
		for i in INSTANCE_COUNT:
			var Inst = CloudsMMeshes[j].multimesh.get_instance_transform_2d(i)
			var InstPos = Inst.get_origin()
			var InstScale = Inst.get_scale() 
			if InstPos.x > CLOUD_DISTANCE:
				InstPos.x -= CLOUD_DISTANCE
			InstPos.x += (30 * delta) / pow(1.5,j)
			CloudsMMeshes[j].multimesh.set_instance_transform_2d(i,Transform2D(0.0,InstScale,0.0,InstPos))
	#print(MMeshInst3.multimesh.get_instance_transform_2d(0).get_origin())
