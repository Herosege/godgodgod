extends Node

var FirstTime = true

var AreaScenes = [
	"res://Scenes/main.tscn",
	"res://Scenes/scene_1.tscn",
	"res://Scenes/village_1.tscn",
	"res://Scenes/village/inside_places.tscn"
]

enum area {wonderful_place, curse_world}

var InDialogue := false
var MenuPaused := false

var CArea : int
var SavedPos = [
	Vector2(109,206), #Coords
	0 #Area
]

var PosSetTravel : Vector2

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

var RotCKilled = false

var SpecialItem = false
var Items = [
	[false,false],#Passives
	[false,false,false]#Weapons
]

enum {VoidSpaghetti}
var BossKilled = [false]

var EnemiesKilled = 0

var stoptime = true

var NumTimesBeatGame : int = 0

var EndingHall = false
var EndingBeer = false

var BestTime = 0.0

var NumDeaths = 0
var LDeaths = -1

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	MVol = load_game("user://config.conf","MusicVolume",MVol)
	SEVol = load_game("user://config.conf","SoundEffectVolume",SEVol)
	
	SignalBus.Save.connect(SaveData)
	
	### DEBUG POSITIONS
	
	Items[Weapon][Axe] = true
	
	#BeerRoom - Curse
	#SavedPos[0] = Vector2(-600,1290)
	#SavedPos[1] = 1
	
	#Start - Curse
	#SavedPos[0] = Vector2(104,208)
	#SavedPos[1] = 1
	
	#onen - main
	#SavedPos[0] = Vector2(4200,-100)
	
	#Bridge - main
	#SavedPos[0] = Vector2(5200,-220)
	
	#henryk - main
	#SavedPos[0] = Vector2(3600,800)
	
	#SecretMilk - main
	#SavedPos[0] = Vector2(1664,-96)
	
	#connector - main
	#SavedPos[0] = Vector2(1860,290)
	
	#Boss - curse
	#SavedPos[0] = Vector2(1480,380)
	#SavedPos[1] = 1
	
	#UnderBridge - main
	#SavedPos[0] = Vector2(7700,400)
	
	#UnderBridge2 - main
	#SavedPos[0] = Vector2(8400,320)
	
	#SECRET BRIDGE - main
	#SavedPos[0] = Vector2(7050,-125)
	
	
	#start - village
	#SavedPos[0] = Vector2(60,400)
	#SavedPos[1] = 2
	
	#tower clouds - village
	#SavedPos[0] = Vector2(935,-632)
	#SavedPos[1] = 2
	
	#first island - village
	#SavedPos[0] = Vector2(570,-1624)
	#SavedPos[1] = 2
	
	#back to tower after island - village
	#SavedPos[0] = Vector2(980,-2010)
	#SavedPos[1] = 2
	
	#Tower after chain jumping - villagze
	#SavedPos[0] = Vector2(790,-3495)
	#SavedPos[1] = 2
	
	#tower moving objects start - village
	#SavedPos[0] = Vector2(662,-4053)
	#SavedPos[1] = 2
	
	#tower last challenge - village
	#SavedPos[0] = Vector2(101,-4863)
	#SavedPos[1] = 2
	
	#village - village 
	SavedPos[0] = Vector2(1101,-5883)
	SavedPos[1] = 2

const CAM_ZOOM = 0.05

func _process(delta):
	if !stoptime:
		SaveTime+=delta
	
	if Input.is_action_just_pressed("debug"):
		pass
		#SavedPos = load_game("user://dinomemories.save","SavedPos",SavedPos)
		#SavedPos[0] = str_to_var(SavedPos[0])
		#Items = load_game("user://dinomemories.save","Items",Items)
		#BossKilled = load_game("user://dinomemories.save","BossKilled",BossKilled)
		#EffectActive = load_game("user://dinomemories.save","EffectActive",EffectActive)
		#SpecialItem = load_game("user://dinomemories.save","SpecialItem",SpecialItem)
		#for i in Items[0].size():
			#Items[0][i] = true
		#Items[Passive][Beer] = true
		#Items[Passive][Milk] = true
		#Items[Weapon][Axe] = true
		
	#if Input.is_action_just_pressed("debug2"):
		#var CAM = get_tree().get_first_node_in_group("cam")
		#
		#if CAM:
			#if CAM.zoom == Vector2(CAM_ZOOM,CAM_ZOOM):
				#CAM.zoom /= CAM_ZOOM
			#else:
				#CAM.zoom *= CAM_ZOOM

var SceneToLoad : String

func LoadScene(SceneChangeTo):
	SceneToLoad = SceneChangeTo
	var LoadingScene = load("res://Scenes/loading_screen.tscn")
	get_tree().call_deferred("change_scene_to_packed",LoadingScene)

func SaveData(type):
	if type == 0:
		save_game("user://dinomemories.save",{
			"FirstTime":FirstTime,
			"SavedPos":[var_to_str(SavedPos[0]),SavedPos[1]],
			"Items":Items,
			"BossKilled":BossKilled,
			"SpecialItem":SpecialItem,
			"SaveTime":SaveTime,
			"NumDeaths":NumDeaths,
			"RotCKilled":RotCKilled
			
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
		
		#if typeof(data[DataName]) != typeof(def):
			#print("corrupted save data ",typeof(def)," and ",typeof(data[DataName]))
			#return def
		
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

func sec_to_time(in_sec):
	var min = floor(in_sec / 60)
	var hrs = floor(in_sec / 3600)
	
	return [(int(in_sec))%60,int(min)%60,hrs]

#settings

var SEVol = 60.0
var MVol = 40.0
