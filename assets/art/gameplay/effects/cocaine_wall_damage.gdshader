shader_type canvas_item;

uniform float health_ratio : hint_range(0.0, 1.0) = 1.0;
uniform float free_edge = 1.0;

float wall_hash(float value) {
	return fract(sin(value * 91.733 + 17.17) * 43758.5453);
}

void fragment() {
	vec4 pixel = texture(TEXTURE, UV) * COLOR;
	float damage = floor((1.0 - health_ratio) * 100.0 + 0.001) / 100.0;
	float band_count = 15.0;
	float band = floor(UV.y * band_count);
	float within_band = abs(fract(UV.y * band_count) - 0.5) * 2.0;
	float irregularity = wall_hash(band);
	float active_threshold = min(0.96, max(0.12, damage * 1.35));
	float active = step(0.005, damage) * step(irregularity, active_threshold);
	float late_damage = smoothstep(0.72, 0.99, damage);
	float depth = (0.018 + irregularity * 0.065) * (0.3 + damage * 0.7 + late_damage * 2.2);
	float rounded_bite = max(0.0, 1.0 - within_band * within_band);
	float edge_distance = mix(UV.x, 1.0 - UV.x, free_edge);
	if (active > 0.5 && edge_distance < depth * rounded_bite) {
		pixel.a = 0.0;
	}
	COLOR = pixel;
}
