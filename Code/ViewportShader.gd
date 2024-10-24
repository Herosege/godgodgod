extends CanvasLayer

var ShaderValues = ["BeerActive","MilkActive"]

func _ready():
	SignalBus.ScreenShaderChange.connect(_on_ScreenShaderChange)

func _on_ScreenShaderChange(value,type):
	var material = $ColorRect.material
	if material is ShaderMaterial:
		material.set_shader_parameter(ShaderValues[type],value)
