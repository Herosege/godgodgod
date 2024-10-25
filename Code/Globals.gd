extends Node

var AreaScenes = [
	"res://Scenes/main.tscn",
	"res://Scenes/scene_1.tscn"
]

enum area {wonderful_place, curse_world}

var CArea : int

var SavedPos = [
	Vector2(109,206), #Coords
	0 #Area
]

var ShaderType = 0

var DisableAction = false

enum {
	Passive,
	Weapon
}

enum {Beer,Milk}
enum {Axe,Gun,Shotgun}

var EffectActive = [false,false]

var SaveTime = 0.0

var SpecialItem = false

var Items = [
	[false,false],#Passives
	[false,false,false]#Weapons
]

enum {VoidSpaghetti}

var BossKilled = [false]

func _ready():
	SignalBus.Save.connect(SaveData)
	#BeerRoom - Curse
	#SavedPos[0] = Vector2(-600,1290)
	#SavedPos[1] = 1
	
	#onen - main
	#SavedPos[0] = Vector2(4100,-100)
	
	#henryk - main
	SavedPos[0] = Vector2(3600,800)
	
	#SecretMilk - main
	#SavedPos[0] = Vector2(1450,160)
	
	#Boss - curse
	#SavedPos[0] = Vector2(1480,380)
	#SavedPos[1] = 1

func _process(delta):
	
	SaveTime+=delta
	
	if Input.is_action_just_pressed("debug"):
		#SavedPos = load_game("user://dinomemories.save","SavedPos",SavedPos)
		#SavedPos[0] = str_to_var(SavedPos[0])
		#Items = load_game("user://dinomemories.save","Items",Items)
		#BossKilled = load_game("user://dinomemories.save","BossKilled",BossKilled)
		#EffectActive = load_game("user://dinomemories.save","EffectActive",EffectActive)
		#SpecialItem = load_game("user://dinomemories.save","SpecialItem",SpecialItem)
		for i in Items[0].size():
			Items[0][i] = true

func SaveData(type):
	if type == 0:
		save_game("user://dinomemories.save",{
			"SavedPos":[var_to_str(SavedPos[0]),SavedPos[1]],
			"Items":Items,
			"BossKilled":BossKilled,
			"SpecialItem":SpecialItem,
			"SaveTime":SaveTime
		})
	if type == 666:
		save_game("user://dinomemories.save",null)

func load_game(file,DataName,def):
	if not FileAccess.file_exists(file):
		return def
	
	var save_game = FileAccess.open(file, FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			return def
		
		var data = json.get_data()
		
		if !data:
			return def
		if !data.has(DataName):
			return def
		
		if typeof(data[DataName]) != typeof(def):
			print("corrupted save data ",typeof(def)," and ",typeof(data[DataName]))
			return def
			
		
		
		return data[DataName]

func save_game(file,SaveCont):
	var SaveFile = FileAccess.open(file, FileAccess.WRITE)
	SaveFile.store_line(JSON.stringify(SaveCont))


func read_file(FilePath):
	var file = FileAccess.open(FilePath, FileAccess.READ)
	if !file:
		return
	var content = file.get_as_text()
	return content
