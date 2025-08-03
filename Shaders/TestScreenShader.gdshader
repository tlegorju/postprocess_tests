shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform vec3 tint_color = vec3(1.0,0.0,0.0);
uniform float tint_strength = 0.5;

vec3 SimpleTint(vec3 baseColor, vec3 tintColor, float tintStrenght)
{
	return mix(baseColor, tintColor, tintStrenght);
}

vec3 MultTint(vec3 baseColor, vec3 tintColor)
{
	return baseColor * tintColor;
}

vec3 LengthTint(vec3 baseColor, vec3 tintColor)
{
	float baseLength = length(baseColor);
	vec3 res = baseColor * tintColor;
	return normalize(res)* baseLength;
}

vec3 AngleColorFilter(vec3 baseColor, vec3 filterColor)
{
	float dotRatio = dot(normalize(baseColor), normalize(filterColor));
	float luminance = dot(baseColor, vec3(0.2126, 0.7152, 0.0722));

	return mix(vec3(luminance), baseColor, dotRatio);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 textColor = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;

	//COLOR.rgb = SimpleTint(textColor, tint_color, tint_strength);
	//COLOR.rgb = MultTint(textColor, tint_color);
	//COLOR.rgb = LengthTint(textColor, tint_color);
	COLOR.rgb = AngleColorFilter(textColor, tint_color);

}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
