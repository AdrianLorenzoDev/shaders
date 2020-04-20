#ifdef GL_ES
precision mediump float;
#endif

#define PROCESSING_COLOR_SHADER
#define NUM_OCTAVES 9

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform int noiseType;

float random (in vec2 vec) {
    return fract(sin(dot(vec.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

vec2 rotate2d(vec2 vec, float angle) {
    return mat2(cos(angle), -sin(angle), sin(angle), cos(angle)) * vec;
}

vec2 scale(vec2 vec, vec2 scale) {
    return mat2(scale.x, 0.0, 0.0, scale.y) * vec;
}

vec2 getScaleTileCoord(vec2 vec, float scale) {
  return vec * scale;
}

// From Patricio Gonzalez Vivo
// https://thebookofshaders.com/13/
// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise(vec2 vec) {
  vec2 i = floor(vec);
  vec2 f = fract(vec);

  float a = random(i);
  float b = random(i + vec2(1.0, 0.0));
  float c = random(i + vec2(0.0, 1.0));
  float d = random(i + vec2(1.0, 1.0));

  vec2 u = smoothstep(0., 1., f);

  return mix(a, b, u.x) +
          (c - a)* u.y * (1.0 - u.x) +
          (d - b) * u.x * u.y;
}

float noiseThree(vec2 vec){
	return noise(vec) * cos(vec.y) / sin(vec.y);
}

float noiseTwo(vec2 vec) {
  return tan(vec.x) / tan(vec.y);
}

float calculateNoise(vec2 pos) {
  switch (noiseType) {
    case 0:
      return noise(pos);
    case 1:
      return noiseTwo(pos);
    case 2:
      return noiseThree(pos);
  }

  return noiseThree(pos);
}

// Fractal Brownian Motion
// https://en.wikipedia.org/wiki/Fractional_Brownian_motion
float fractalBrownianMotion(in vec2 pos) {
  float res = 0.0;

  // Params
  float frequency = 0.0;
  float amplitude = 0.6;
  float lacunarity = 2.5;
  float gain = 0.6;

  for (int i = 0; i < NUM_OCTAVES; i++) {
    res += amplitude * calculateNoise(pos);
    amplitude *= gain;
    pos *= lacunarity;
  }
  return res;
}

void main() {
  vec2 pos = gl_FragCoord.xy / u_resolution.xy;
  vec2 mouse = u_mouse.xy / u_resolution.xy;

  float scale = u_resolution.x/u_resolution.y;
  pos = getScaleTileCoord(pos, scale);

  float mistMovementSpeed = 0.07;
  float mistRotationSpeed = 0.05;

  vec3 posValue = vec3(fractalBrownianMotion(
    rotate2d(pos * vec2(sin(mistMovementSpeed*u_time)), mistRotationSpeed * cos(u_time))
  ));
  posValue = posValue * vec3(fractalBrownianMotion(
    rotate2d(pos * vec2(cos(mistMovementSpeed*u_time)), mistRotationSpeed * sin(u_time))
  ));

  vec3 color = vec3(0.12915 * mouse.x, 0.4853, 0.24115 * mouse.y);
  gl_FragColor = vec4(posValue * color, 1.0);
}
