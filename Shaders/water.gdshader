shader_type canvas_item;

uniform sampler2D Texture : filter_nearest;
uniform sampler2D NoiseTexture : filter_nearest,repeat_enable;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV;
	float time = TIME;
	
	vec4 Noise = texture(NoiseTexture,UV);
	
	float amplitude = 0.06;
	float frequency = 15.0;
	float speed = 2.0
	;
	float wave = sin(uv.x * frequency + time * speed+uv.y * 5.0) * amplitude * Noise.x;
	
	vec4 color = texture(Texture,UV);
	
	vec2 displaced_uv = vec2(uv.x, uv.y + wave);
	
	if (displaced_uv.y >0.43)
		COLOR = color;
	else
		COLOR.a = 0.0;
	//COLOR.rgb = color.rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
