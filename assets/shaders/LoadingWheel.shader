shader_type canvas_item;

uniform vec4 ui_color : hint_color;
uniform float width : hint_range(0.0f, 1.0f) = 0.7f;

void fragment() {
	float progress = mod(TIME, 1.0f);
	vec4 color = texture(TEXTURE, UV);
	float diff = progress - color.r;
	
	// Eliminate discontinuities between (-)1 and 0.
	if (diff > 0.5) {
		diff -= 1.0; // "Pull down" values close to 1 to values close to 0.
	} else if (diff < -0.5) {
		diff += 1.0; // "Pull up" values close to -1 to values close to 0.
	}
	
	COLOR.rgb = vec3(1.0);
	COLOR.a = color.a * (smoothstep(-width/2.0, 0.0, diff)
						 - smoothstep(0.0, width/2.0, diff));
}
