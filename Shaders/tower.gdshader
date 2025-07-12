shader_type canvas_item;
uniform sampler2D noisetex : repeat_enable;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV;
	vec4 NoiseVal = texture(noisetex,vec2(uv.x+TIME/4.0,uv.y+TIME/32.0));
	COLOR = NoiseVal;
	COLOR.a -= NoiseVal.x*1.2;
	COLOR.a /= 5.0;

}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
