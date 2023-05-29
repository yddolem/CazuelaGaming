shader_type canvas_item;

uniform vec4 color : source_color;

void fragment() {
	vec4 original = texture(TEXTURE, UV);
	COLOR = color;
	COLOR.a = original.a;
}
