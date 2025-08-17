shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform bool _useMixTint=false;
uniform bool _useMultTint=false;
uniform bool _useLengthTint=false;
uniform bool _useAngleColFilter=false;
uniform bool _useInvertCol=false;

uniform vec3 _tint_color = vec3(1.0,0.0,0.0);
uniform float _tint_strength = 0.5;

uniform float _brightness = 0.2;
uniform float _saturation = 1.0;
uniform float _contrast = 1.0;

uniform float _red_boost = 1.5;
uniform float _green_boost = 0.8;
uniform float _blue_boost = 1.5;

vec3 MixTint(vec3 baseColor, vec3 tintColor, float tintStrenght)
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

vec3 InvertColorFilter(vec3 baseColor)
{
	return 1.0 - baseColor;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 textColor = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;

	vec3 color=textColor;

	if(_useMixTint)
		color = MixTint(textColor, _tint_color, _tint_strength);
	if(_useMultTint)
		color = MultTint(textColor, _tint_color);
	if(_useLengthTint)
		color = LengthTint(textColor, _tint_color);
	if(_useAngleColFilter)
		color = AngleColorFilter(textColor, _tint_color);
	if(_useInvertCol)
		color = InvertColorFilter(textColor);

	// Brightness
	color += _brightness;

	// Saturation (color intensity)
		// Luminance is the gray scale value of the pixel. Sum of the component divided by 3
		// This approach is straightforward but doesn't take the different perception of colors into account
		//float luminance = dot(color, vec3(1.0/3.0));
		// this is more accurate (takes eye sensitivity into account)
	float luminance = dot(color, vec3(0.2126, 0.7152, 0.0722));
	color = mix(vec3(luminance), color, _saturation);

	// Contrast (light intensity)
	float midpoint = 0.5;
	//color = clamp((color - midpoint) * _contrast + midpoint, 0.0, 1.0);
	color = clamp((color - midpoint) * _contrast + midpoint, 0.0, 1.0);

	// color boosting per channel
	color = pow(color, vec3(_red_boost, _green_boost, _blue_boost));

	COLOR.rgb = color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
