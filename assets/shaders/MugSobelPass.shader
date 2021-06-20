shader_type spatial;

uniform vec4 color : hint_color;
uniform float energy = 1.0;

float linearize_depth(float depth, vec2 screen_uv, mat4 inv_projection_matrix) {
	vec3 ndc = vec3(screen_uv, depth) * 2.0 - 1.0;
	vec4 view = inv_projection_matrix * vec4(ndc, 1.0);
	view.xyz /= view.w;
	return -view.z;
}

void fragment() {
		vec2 px = 1.0 / VIEWPORT_SIZE;
		float d00 = linearize_depth(texture(DEPTH_TEXTURE, SCREEN_UV + px * vec2(-1.0, -1.0)).r, SCREEN_UV, INV_PROJECTION_MATRIX);
		float d01 = linearize_depth(texture(DEPTH_TEXTURE, SCREEN_UV + px * vec2( 0.0, -1.0)).r, SCREEN_UV, INV_PROJECTION_MATRIX);
		float d02 = linearize_depth(texture(DEPTH_TEXTURE, SCREEN_UV + px * vec2( 1.0, -1.0)).r, SCREEN_UV, INV_PROJECTION_MATRIX);
		float d10 = linearize_depth(texture(DEPTH_TEXTURE, SCREEN_UV + px * vec2(-1.0,  0.0)).r, SCREEN_UV, INV_PROJECTION_MATRIX);
		float d12 = linearize_depth(texture(DEPTH_TEXTURE, SCREEN_UV + px * vec2( 1.0,  0.0)).r, SCREEN_UV, INV_PROJECTION_MATRIX);
		float d20 = linearize_depth(texture(DEPTH_TEXTURE, SCREEN_UV + px * vec2(-1.0,  1.0)).r, SCREEN_UV, INV_PROJECTION_MATRIX);
		float d21 = linearize_depth(texture(DEPTH_TEXTURE, SCREEN_UV + px * vec2( 0.0,  1.0)).r, SCREEN_UV, INV_PROJECTION_MATRIX);
		float d22 = linearize_depth(texture(DEPTH_TEXTURE, SCREEN_UV + px * vec2( 1.0,  1.0)).r, SCREEN_UV, INV_PROJECTION_MATRIX);
		float Gx = - 1.0 * d00 + 1.0 * d02
				   - 2.0 * d10 + 2.0 * d12
				   - 1.0 * d20 + 1.0 * d22;
		float Gy = - 1.0 * d00 - 2.0 * d01 - 1.0 * d02
				   + 1.0 * d20 + 2.0 * d21 + 1.0 * d22;
		float sobel = Gx*Gx+Gy*Gy;
		sobel = 1.0 - exp(-sobel);
		ALBEDO = vec3(0.0); // Black base...
		EMISSION = energy * color.rgb * vec3(sobel); // ... and sobel emission.
	}