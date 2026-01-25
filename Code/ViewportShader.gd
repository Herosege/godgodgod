extends CanvasLayer

var ShaderValues = ["BeerActive","MilkActive"]

func _ready():
	SignalBus.ScreenShaderChange.connect(_on_ScreenShaderChange)
	for i in Globals.EffectActive.size():
		if Globals.EffectActive[i] == true:
			_on_ScreenShaderChange(true,i)

func _on_ScreenShaderChange(value,type):
	var material = $ColorRect.material
	if material is ShaderMaterial:
		material.set_shader_parameter(ShaderValues[type],value)
	if type == Globals.Beer:
		Globals.EffectActive[Globals.Beer] = value
