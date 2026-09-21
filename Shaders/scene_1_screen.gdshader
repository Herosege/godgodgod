shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform bool BeerActive = false;
uniform bool WaterActive = false;

void fragment() {
	if (BeerActive){
		vec2 uv = SCREEN_UV;
		float time = TIME;

		float amplitude = 0.012;
		float frequency = 12.0;
		float speed = 0.7;
		float wave = sin(uv.x * frequency + time * speed) * amplitude;

		vec2 displaced_uv = vec2(uv.x, uv.y + wave);

		vec4 color = textureLod(SCREEN_TEXTURE, displaced_uv,0.0);

		COLOR.a = 1.0;
		COLOR.rgb = color.rgb;
	}
	else{
		COLOR.a = 0.0;
	}
}
