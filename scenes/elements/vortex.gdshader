shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	//vec2 distortedUV = SCREEN_UV + texture(TEXTURE, UV).r * 0.05;
	//vec4 screenColor = texture(SCREEN_TEXTURE, distortedUV);
	//COLOR = screenColor;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
