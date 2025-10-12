shader_type canvas_item;

uniform float deflection : hint_range(0.0, 100.0);
uniform float max_bend = 70.0;
uniform float active_threshold = 1.5; // below this, no glow
uniform vec3 base_color : source_color = vec3(0.25, 0.15, 0.05); // beam brown
uniform float glow_strength = 1.4;

void fragment() {
	float ratio = clamp(deflection / max_bend, 0.0, 1.0);

	vec3 final_color = base_color;

	if (ratio >= active_threshold / max_bend) {
		// Color ramp: green → yellow → red
		vec3 heat_color;
		if (ratio < 0.5) {
			heat_color = mix(vec3(0.0, 1.0, 0.4), vec3(1.0, 1.0, 0.0), ratio * 2.0);
		} else {
			heat_color = mix(vec3(1.0, 1.0, 0.0), vec3(1.0, 0.0, 0.0), (ratio - 0.5) * 2.0);
		}

		// Gentle shimmer (for visibility)
		float shimmer = 0.9 + 0.1 * sin(TIME * 2.0 + UV.x * 8.0);

		final_color = mix(base_color, heat_color * shimmer * glow_strength, ratio);
	}

	COLOR = vec4(final_color, 1.0);
}
