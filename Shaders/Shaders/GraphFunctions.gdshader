shader_type canvas_item;

uniform float multiplier = 0.5;
uniform float offset = 0.0; 
uniform int functionId = 7;
uniform bool useTime = false;
uniform float timeMultiplier = 0.5;

float parabola( float x, float k ){
    return pow( 4.0*x*(1.0-x), k );
}

float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

void fragment() {
	// clamp x to -1:1
	float x = UV.x * 2.0 - 1.0;
	if (useTime){
		x *= sin(TIME*timeMultiplier);
	}
	float y = UV.x;
	switch(functionId){
		case 0:
			y = 1.0 - pow(abs(x),multiplier);
			break;
		case 1:
			y = pow(cos(PI * x / 2.0),multiplier);
			break;
		case 2:
			y = 1.0 - pow(abs(sin(PI * x / 2.0)),multiplier);
			break;
		case 3:
			y = pow(min(cos(PI * x / 2.0),1.0 - abs(x)),multiplier);
			break;
		case 4:
			y = 1.0 - pow(max(0.0,abs(x) * 2.0 - 1.0), multiplier);
			break;
		case 5:
			y = step(multiplier,x);
			break;
		case 6:
			y = smoothstep(multiplier,multiplier + 1.0,x);
			break;
		case 7:
			y = sin(x)* multiplier;
			break;
		default:
			y = UV.x;
			break;
	}
    

    vec3 color = vec3(y);

    float pct = plot(UV,y);
    color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

	COLOR = vec4(color,1.0);
}