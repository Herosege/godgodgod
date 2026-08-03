extends Node

const PATH_TO_PERMASAVE = "user://perma_v2.save"
const PATH_TO_GAMESAVE = "user://dinomemories_v2.save"
const PATH_TO_CONFSAVE = "user://config.conf"


var FirstTime = true

var AreaScenes = [
	"res://Scenes/main.tscn",
	"res://Scenes/scene_1.tscn",
	"res://Scenes/village_1.tscn",
	"res://Scenes/village/inside_places.tscn",
	"res://Scenes/village/fake_hall.tscn",
	"res://Scenes/Bog/bog.tscn",
	"res://Scenes/main-postending.tscn",
	"res://Scenes/scene_1-postending.tscn",
	"res://Scenes/temple/temple.tscn"
]

var TravelingBack = false

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

enum {Beer,Milk,Water}
enum {Axe,Shotgun}

var EffectActive = [false,false]

var SaveTime = 0.0

var RotCKilled = false

var SpecialItem = false
var Items = [
	[false,false,false],#Passives
	[false,false]#Weapons
]

enum {VoidSpaghetti,Balbina,Horse}
var BossKilled = [false,false,false]

var EnemiesKilled = 0

var stoptime = true

var NumTimesBeatGame : int = 0

enum End {EndingWater,EndingPeace,EndingPain,EndingTravel}

var Endings = [false,false,false,false]

var BestTime = 0.0

var NumDeaths : int = 0

enum State {HardMode} 
enum StateRec {BTime,BDeath,NumTimesBeat}
var ExStatesRecords = [
	[0.0,-1,0]
]

var VPort = Vector2(640,480)

var LDeaths : int = -1

var Rombs := 0

enum SEID {RombGet}

func _ready():
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	RenderingServer.set_default_clear_color(Color.BLACK)
	MVol = load_game(PATH_TO_CONFSAVE,"MusicVolume",MVol)
	SEVol = load_game(PATH_TO_CONFSAVE,"SoundEffectVolume",SEVol)
	TimerOn = load_game(PATH_TO_CONFSAVE,"TimerOn",TimerOn)
	KeybindList = load_game(PATH_TO_CONFSAVE,"Keybinds",KeybindList)
	SignalBus.Save.connect(SaveData)
	
	### DEBUG POSITIONS
	if OS.is_debug_build():
		pass
		#BeerRoom - Curse
		#SavedPos[0] = Vector2(-600,1290)
		#SavedPos[1] = 1
		#SpecialItem = true
		#Start - Curse
		
		
		#onen - main
		#SavedPos[0] = Vector2(4200,-100)
		
		#Bridge - main
		#SavedPos[0] = Vector2(5200,-220)
		
		#henryk - main
		#SavedPos[0] = Vector2(3600,800)
		#
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
		#SavedPos[0] = Vector2(1101,-5883)
		#SavedPos[1] = 2
		
		#FakeHall - start
		#SavedPos[0] = Vector2(530,-440)
		#SavedPos[1] = 4
		
		#FakeHall - third obstacle
		#SavedPos[0] = Vector2(1980,375)
		#SavedPos[1] = 4
		
		#FakeHall - sixth obstacle
		#SavedPos[0] = Vector2(3880+640,375)
		#SavedPos[1] = 4
		
		#village - EXTRA
		#SavedPos[0] = Vector2(9043,-26)
		#SavedPos[1] = 2
		
		#village - EXTRA2
		#SavedPos[0] = Vector2(9146,-97)
		#SavedPos[1] = 2
		
		#village - EXTRA3
		#SavedPos[0] = Vector2(9080,-194)
		#SavedPos[1] = 2
		
		#Bog - start
		#SavedPos[0] = Vector2(120,400)
		#SavedPos[1] = 5
		
		#main - traveling - past moving spikes
		#SavedPos[0] = Vector2(1664,-96)
		#SavedPos[1] = 6
		
		#Curse world - traveling - past balls
		#SavedPos[0] = Vector2(2000,1160)
		#SavedPos[1] = 7
		
		#Curse world - traveling - past exjumps
		#SavedPos[0] = Vector2(2600,940)
		#SavedPos[1] = 7
		
		#Curse world - traveling - past gate
		#SavedPos[0] = Vector2(-126,908)
		#SavedPos[1] = 7
		
		#Curse world - traveling - boss
		#SavedPos[0] = Vector2(-1696,540)
		#SavedPos[1] = 7
		
		#Temple - start 
		#SavedPos[0] = Vector2(319,-560)
		#SavedPos[1] = 8
		
		#Temple - secret right
		#SavedPos[0] = Vector2(1590,-980)
		#SavedPos[1] = 8
		
		#Temple - right 4 room
		#SavedPos[0] = Vector2(2330,-1024)
		#SavedPos[1] = 8
		#SavedPos[0] = Vector2(2177,-1490)
		#SavedPos[1] = 8
		
		#Temple - left upper start 
		#SavedPos[0] = Vector2(-1840,-1040)
		#SavedPos[1] = 8
		
		#Temple - left roof 
		#SavedPos[0] = Vector2(-720,-1610)
		#SavedPos[1] = 8
		
		#Temple - upper tower 
		#SavedPos[0] = Vector2(670,-2920)
		#SavedPos[1] = 8
		
		#Temple - half pyramid tip
		#SavedPos[0] = Vector2(2446,-2990)
		#SavedPos[1] = 8
		
		#Temple - gungungun
		#SavedPos[0] = Vector2(4065,-2100)
		#SavedPos[1] = 8
		
		#Temple - horse boss 
		#SavedPos[0] = Vector2(1350,-3400)
		#SavedPos[1] = 8

const CAM_ZOOM = 0.05

func _input(event):
	if event is InputEventKey and OS.is_debug_build():
		if event.is_pressed() and event.keycode >= 48 and event.keycode <= 58  and not event.is_echo():
			LoadScene(AreaScenes[event.keycode - 48])

func _process(delta):
	if !stoptime:
		SaveTime+=delta
	
	if Input.is_action_just_pressed("RESETGAME"):
		ResetMemoryGlobal()
	
	
	if Input.is_action_just_pressed("debug") and OS.is_debug_build():
		pass
		#ResetMemoryGlobal()
		#SavedPos = load_game("user://dinomemories.save","SavedPos",SavedPos)
		#SavedPos[0] = str_to_var(SavedPos[0])
		#Items = load_game("user://dinomemories.save","Items",Items)
		#BossKilled = load_game("user://dinomemories.save","BossKilled",BossKilled)
		#EffectActive = load_game("user://dinomemories.save","EffectActive",EffectActive)
		#SpecialItem = load_game("user://dinomemories.save","SpecialItem",SpecialItem)
		#for i in Items[0].size():
			#Items[0][i] = true
		Items[Passive][Beer] = true
		Items[Passive][Milk] = true
		Items[Passive][Water] = true
		Items[Weapon][Axe] = true
		Items[Weapon][Shotgun] = true
		SpecialItem = true
	if Input.is_action_just_pressed("debug2"):
		#var CAM = get_tree().get_first_node_in_group("cam")
		#TravelBack()
		#get_tree().change_scene_to_file("res://Scenes/intro.tscn")
		pass
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
		save_game(PATH_TO_GAMESAVE,{
			"FirstTime":FirstTime,
			"SavedPos":[var_to_str(SavedPos[0]),SavedPos[1]],
			"Items":Items,
			"BossKilled":BossKilled,
			"SpecialItem":SpecialItem,
			"SaveTime":SaveTime,
			"NumDeaths":NumDeaths,
			"RotCKilled":RotCKilled,
			"EventArray":STEvents.EventArray,
			"OneTimeJammers":STEvents.OneTimeJammers,
			"RombsGotten":STEvents.RombsGotten,
			"TravelingBack":TravelingBack
		})
	if type == 666:
		save_game(PATH_TO_GAMESAVE,null)
	if type == 667:
		save_game(PATH_TO_GAMESAVE,null)
		ResetMemoryGlobal()

func TravelBack():
	TravelingBack = true
	SavedPos[0] = Vector2(320,320)
	SavedPos[1] = 0
	SpecialItem = false
	NumDeaths = 0
	SaveTime = 0.0
	Items = [
		[false,false,false],#Passives
		[false,false]#Weapons
	]

func SavePerma():
	save_game(PATH_TO_PERMASAVE,{
		"Endings":Endings,
		"BGame":NumTimesBeatGame,
		"BestTime":BestTime,
		"LDeaths":LDeaths,
		"ExStatesRecords":ExStatesRecords
	})

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
	
	return [(int(in_sec))%60,int(min)%60,int(hrs)]

func LoadKeybinds():
	if KeybindList:
		for key in KeybindList.keys():
			if KeybindList[key][0] is not float:
				break
			InputMap.action_erase_events(key)
			var NInp = InputEventKey.new()
			NInp.physical_keycode = KeybindList[key][0]
			InputMap.action_add_event(key,NInp)


func GetParentWithMethod(NNode:Node,MethodName:String):
	if NNode.has_method(MethodName):
		return NNode
	while NNode.get_parent() != null:
		if NNode.has_method(MethodName):
			return NNode
		NNode = NNode.get_parent()
	return null

#settings

var SEVol = 60.0
var MVol = 40.0

var TimerOn = false

var KeybindList = {}

func ResetMemoryGlobal(BackToIntro:=true):
	TravelingBack = false

	InDialogue = false
	MenuPaused = false
	CArea = 0
	SavedPos = [
		Vector2(109,206), #Coords
		0 #Area
	]
	
	PosSetTravel = Vector2.ZERO
	ShaderType = 0
	DisableAction = false
	
	EnemiesKilled = 0
	stoptime = true
	
	EffectActive = [false,false]
	
	SaveTime = 0.0
	
	RotCKilled = false
	
	SpecialItem = false
	Items = [
		[false,false,false],#Passives
		[false,false]#Weapons
	]
	
	BossKilled = [false,false]
	if get_tree().current_scene.name != "Intro" and BackToIntro:
		get_tree().change_scene_to_file("res://Scenes/intro.tscn")
	for i in STEvents.EventArray.size():
		STEvents.EventArray[i] = false
	STEvents.OneTimeJammers.clear()

#func FindPlayer(node):
	#while node != null:
		#if node.is_in_group("Player"):
			#return node
		#node = node.get_parent()
	#return null
