shader_type canvas_item;

uniform float health_ratio : hint_range(0.0, 1.0) = 1.0;
uniform float free_edge = 1.0;

float wall_hash(float value) {
	return fract(sin(value * 91.733 + 17.17) * 43758.5453);
}

void fragment() {
	vec4 pixel = texture(TEXTURE, UV) * COLOR;
	float damage_steps = floor((1.0 - health_ratio) * 100.0 + 0.001);
	float band_count = 12.0;
	float band = floor(UV.y * band_count);
	float within_band = abs(fract(UV.y * band_count) - 0.5) * 2.0;
	float rounded_bite = max(0.0, 1.0 - within_band * within_band);
	float edge_distance = mix(UV.x, 1.0 - UV.x, free_edge);
	float first_step = band + 1.0;
	float passes = max(0.0, floor((damage_steps - first_step) / band_count) + 1.0);
	float micro_depth = step(first_step, damage_steps) * (0.048 + min(9.0, passes) * 0.016) * (0.32 + rounded_bite * 0.68);
	float major_count = min(9.0, floor(damage_steps / 10.0));
	float fracture_depth = 0.0;
	for (int index = 0; index < 9; index++) {
		float active = step(float(index + 1), major_count);
		float variant = mod(float(index), 4.0);
		float center = 0.25 + mod(float(index) * 0.337, 0.52);
		float radius = 0.065 + variant * 0.008;
		float distance = abs(UV.y - center) / radius;
		float profile = max(0.0, 1.0 - distance);
		if (variant > 0.5 && variant < 1.5) profile = step(distance, 0.82);
		if (variant > 2.5) profile = max(profile, max(0.0, 1.0 - abs(UV.y - center - radius * 0.72) / (radius * 0.46)) * 0.7);
		fracture_depth = max(fracture_depth, active * (0.13 + variant * 0.015) * profile);
	}
	float depth = max(micro_depth, fracture_depth);
	if (edge_distance < depth) {
		pixel.a = 0.0;
	} else if (edge_distance < depth + 0.018 && depth > 0.0) {
		pixel.rgb = mix(pixel.rgb, vec3(0.58, 0.67, 0.82), 0.82);
	}
	COLOR = pixel;
}
