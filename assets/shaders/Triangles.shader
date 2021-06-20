shader_type spatial;

uniform sampler2D holotex;
uniform float progress : hint_range(0.0f, 1.0f) = 0.0f;
uniform float outer_width : hint_range(0.0f, 1.0f) = 0.5f;
uniform float inner_width : hint_range(0.0f, 1.0f) = 0.1f;

void fragment() {
	vec4 color = texture(holotex, UV);
	
	// Remap the progress so that for 0 and 1, there will be no triangles visible.
	float mapped_progress = (1.0f + outer_width) * progress - 0.5f * outer_width;
	 
	ALPHA= smoothstep(mapped_progress - 0.5f * outer_width, mapped_progress - 0.5f * inner_width, color.r)
			- smoothstep(mapped_progress + 0.5f * inner_width, mapped_progress + 0.5f * outer_width, color.r);		
	ALPHA *= smoothstep(0.75, 0.8, color.g) - smoothstep(0.8, 0.85, color.g);
	
	EMISSION = vec3(1.0f);
}