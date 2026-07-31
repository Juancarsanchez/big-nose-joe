shader_type canvas_item;

uniform float health_ratio : hint_range(0.0, 1.0) = 1.0;
uniform float free_edge = 1.0;

void fragment() {
	vec4 pixel = texture(TEXTURE, UV) * COLOR;
	float damage_steps = floor((1.0 - health_ratio) * 100.0 + 0.001);
	float band_count = 12.0;
	float band = floor(UV.y * band_count);
	float within_band = abs(fract(UV.y * band_count) - 0.5) * 2.0;
	float rounded_bite = max(0.0, 1.0 - within_band * within_band);
	float direction = mix(-1.0, 1.0, free_edge);
	float edge_distance = 1.0;
	float edge_found = 0.0;
	for (int sample_index = 1; sample_index <= 32; sample_index++) {
		float travel = float(sample_index) * 0.0125;
		vec2 sample_uv = UV + vec2(direction * travel, 0.0);
		float outside = step(sample_uv.x, 0.0) + step(1.0, sample_uv.x);
		float sample_alpha = outside > 0.0 ? 0.0 : texture(TEXTURE, sample_uv).a;
		if (edge_found < 0.5 && sample_alpha < 0.05) {
			edge_distance = travel;
			edge_found = 1.0;
		}
	}
	float first_step = band + 1.0;
	float passes = max(0.0, floor((damage_steps - first_step) / band_count) + 1.0);
	float micro_depth = step(first_step, damage_steps) * (0.048 + min(9.0, passes) * 0.016) * (0.32 + rounded_bite * 0.68);
	float major_count = min(9.0, floor(damage_steps / 10.0));
	float fracture_depth = 0.0;
	for (int index = 0; index < 9; index++) {
		float active = step(float(index + 1), major_count);
		float variant = mod(float(index), 4.0);
		float center = 0.25 + mod(float(index) * 0.337, 0.52);
		float radius = 0.115 + variant * 0.01;
		float distance = abs(UV.y - center) / radius;
		float profile = max(0.0, 1.0 - distance);
		if (variant > 0.5 && variant < 1.5) profile = step(distance, 0.84);
		if (variant > 2.5) profile = max(profile, max(0.0, 1.0 - abs(UV.y - center - radius * 0.68) / (radius * 0.48)) * 0.72);
		fracture_depth = max(fracture_depth, active * (0.30 + variant * 0.02) * profile);
	}
	float depth = max(micro_depth, fracture_depth);
	float rim = 0.022 + step(0.001, fracture_depth) * 0.022;
	if (edge_distance < depth) {
		pixel.a = 0.0;
	} else if (edge_distance < depth + rim && depth > 0.0) {
		pixel.rgb = mix(pixel.rgb, vec3(0.67, 0.75, 0.9), 0.92);
	} else if (edge_distance < depth + rim + 0.014 && fracture_depth > 0.0) {
		pixel.rgb = mix(pixel.rgb, vec3(0.19, 0.12, 0.29), 0.72);
	}
	COLOR = pixel;
}
