// code adapted for LOVE from https://www.shadertoy.com/view/3dBSRD

extern float count;
extern float time;

float random (vec2 st) {
    return fract(sin(dot(st.xy,vec2(12.9898,78.233)))*43758.5453123);
}

float blend(const in float x, const in float y) {
  return (x < 0.5) ? (2.0 * x * y) : (1.0 - 2.0 * (1.0 - x) * (1.0 - y));
}

vec4 overlay(const in vec4 x, const in vec4 y, const in float opacity) {
  vec4 z = vec4(
    blend(x.r, y.r),
    blend(x.g, y.g),
    blend(x.b, y.b),
    blend(x.a, y.a)
  );
  return z * opacity + x * (1.0 - opacity);
}

vec4 effect(vec4 inputColor, Image texture, vec2 uv, vec2 pixel_coords)
{
  vec2 sl = vec2(sin(uv.y * count), cos(uv.y * count));
  vec3 scanlines = vec3(sl.x, sl.y, sl.x);
  vec4 pixel = Texel(texture, uv );
  pixel += vec4(random(uv * time)) * 0.08;
  pixel += pixel * sin(110.0 * time) * 0.03;
  return overlay(pixel, vec4(scanlines, 1.0), 0.06);
}