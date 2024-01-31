shader_type canvas_item;  // Defines the shader type as a canvas item shader, used for 2D rendering.

// Uniform variables that can be set from the Godot editor.
uniform vec3 color: source_color = vec3(1);  // The color to blend with, defaulting to white (vec3(1) is shorthand for vec3(1.0, 1.0, 1.0)).
uniform float progress: hint_range(0.0, 1.0, 0.1) = 0;  // The blending progress, a value between 0.0 and 1.0.

void fragment() {
	vec4 current_color = texture(TEXTURE, UV);  // Fetches the current color of the texture at the UV coordinates.
	vec4 target_color = mix(current_color, vec4(color, current_color.a), progress);  // Linearly interpolates between the current color and the target color based on the progress value.
	COLOR = target_color;  // Sets the final color to be the result of the mix.
}
