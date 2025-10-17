shader_type spatial;
uniform sampler2D overlay: source_color;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec4 desired_color: source_color = vec4(1.0, 0.0, 0.0, 1.0);

vec3 soft_light(vec4 base, vec4 blend){
	vec4 limit = step(0.5, blend);
	return mix(2.0 * base * blend + base * base * (1.0 - 2.0 * blend), sqrt(base) * (2.0 * blend - 1.0) + (2.0 * base) * (1.0 - blend), limit).rgb;
}


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 screen_sample = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 overlay_sample = texture(overlay, SCREEN_UV);
	ALBEDO = soft_light(texture(SCREEN_TEXTURE, SCREEN_UV),desired_color);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
