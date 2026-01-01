shader_type canvas_item;

uniform sampler2D Noise : repeat_enable;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 NoiseVal = texture(Noise,vec2(UV.x+TIME*0.1,UV.y+sin(TIME*0.15)*0.15));
	if (NoiseVal.x>0.2){
		COLOR = vec4(NoiseVal.x*1.5*(0.8-UV.y),0.0,0.0,1.0);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
