shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(0.055, 0.025, 0.065, 1.0);
uniform float outline_size = 2.0;

void fragment() {
	vec4 grain = texture(TEXTURE, UV);
	vec2 offset = TEXTURE_PIXEL_SIZE * outline_size;
	float edge = 0.0;
	edge = max(edge, texture(TEXTURE, UV + vec2(offset.x, 0.0)).a);
	edge = max(edge, texture(TEXTURE, UV - vec2(offset.x, 0.0)).a);
	edge = max(edge, texture(TEXTURE, UV + vec2(0.0, offset.y)).a);
	edge = max(edge, texture(TEXTURE, UV - vec2(0.0, offset.y)).a);
	edge = max(edge, texture(TEXTURE, UV + offset).a);
	edge = max(edge, texture(TEXTURE, UV - offset).a);
	vec4 outlined = mix(outline_color, grain, grain.a);
	outlined.a = max(grain.a, edge);
	COLOR = outlined * COLOR;
}
