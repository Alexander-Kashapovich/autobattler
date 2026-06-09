shader_type canvas_item;

uniform vec2 width = vec2(0.05);
uniform float speed = 1.0;

void fragment() {
	float pos = fract(TIME * speed);
	vec2 uv = vec2(UV.x - pos,UV.y - 0.5);
	float x = smoothstep(-width.x,width.x,uv.x) - step(width.x,uv.x);
	float y = step(-width.y,uv.y - uv.x) - step(width.y,uv.y + uv.x);
	COLOR.a = x * y;
	
}
