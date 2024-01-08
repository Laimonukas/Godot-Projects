shader_type canvas_item;

uniform vec2 VectorNoiseAmount = vec2(5.5,80.5);
uniform float Offset = 2344.0;
uniform float ColumnAmount = 3.0;
uniform float RowAmount = 5.0;
uniform vec3 waterColor = vec3(0.0,0.0,1.0);
uniform float speed = 1.0;

vec2 random(vec2 uv) {;
	return vec2(fract(sin(dot(uv.xy,
		clamp(VectorNoiseAmount,vec2(0.1,0.1),vec2(1.0,1.0)))) * Offset));
}

float worley(vec2 uv, float columns, float rows) {
	
	vec2 index_uv = floor(vec2(uv.x * columns, uv.y * rows));
	vec2 fract_uv = fract(vec2(uv.x * columns, uv.y * rows));
	
	float minimum_dist = 1.0;  
	
	for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 point = random(index_uv + neighbor);
			point = vec2( cos(TIME * point.x * speed), sin(TIME * point.y * speed) ) * 0.5 + 0.5;
			
			
			//point = random(index_uv + neighbor);
		
			
			vec2 diff = neighbor + point - fract_uv;
			float dist = length(diff);
			minimum_dist = min(minimum_dist, dist);
		}
	}
	
	return minimum_dist;
}



void fragment() {
	vec2 st = UV;
	st.y -= TIME * speed;
	float worley = worley(st, ColumnAmount, RowAmount);
	vec3 clampedWorley = clamp(vec3(worley),0.3,1.0);
	vec3 col = mix(clampedWorley,waterColor,0.9);
	
	COLOR = vec4(col, 1.0);
	
}