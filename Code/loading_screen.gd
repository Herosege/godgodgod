extends Control

var Progress = []
var SceneChangeTo : String
var LoadStatus 

func _ready():
	SceneChangeTo = Globals.SceneToLoad
	if SceneChangeTo:
		ResourceLoader.load_threaded_request(SceneChangeTo)

func _process(delta):
	if SceneChangeTo:
		LoadStatus = ResourceLoader.load_threaded_get_status(SceneChangeTo,Progress)
		$TextureProgressBar.value = Progress[0]*100.0
		if LoadStatus == ResourceLoader.THREAD_LOAD_LOADED:
			var LoadedScene = ResourceLoader.load_threaded_get(SceneChangeTo)
			get_tree().change_scene_to_packed(LoadedScene)
