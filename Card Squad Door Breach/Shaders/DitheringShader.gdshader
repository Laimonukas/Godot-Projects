shader_type canvas_item;


uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D ditheringTex: repeat_enable;
uniform float ditherFloat = 16.0;

void fragment() {
	COLOR = step(texture(ditheringTex, FRAGCOORD.xy/ditherFloat).g, texture(screen_texture,UV));
}