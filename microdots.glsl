precision highp float;

/** @resolution */
uniform vec2 u_resolution;

/**
 * @label Cell size
 * @range 4, 24
 * @default 9
 */
uniform float u_cell;

/**
 * @label Dot size (centre)
 * @range 0, 0.5
 * @default 0.1
 */
uniform float u_rMin;

/**
 * @label Dot size (rim)
 * @range 0, 0.6
 * @default 0.4
 */
uniform float u_rMax;

/**
 * @label Angle
 * @range 0, 90
 * @default 22
 */
uniform float u_angle;

/**
 * @label Colour 1
 * @color
 * @default #F8CB41
 */
uniform vec3 u_c1;

/**
 * @label Colour 2
 * @color
 * @default #96C13D
 */
uniform vec3 u_c2;

/**
 * @label Colour 3
 * @color
 * @default #2E86B8
 */
uniform vec3 u_c3;

/**
 * @label Colour 4
 * @color
 * @default #E5483A
 */
uniform vec3 u_c4;

float hash(vec2 p) {
  return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void main() {
  vec2 uv = gl_FragCoord.xy / u_resolution;
  vec2 p = (uv - 0.5) * u_resolution;
  float dist = length(p) / (0.5 * min(u_resolution.x, u_resolution.y));

  float a = radians(u_angle);
  mat2 rot = mat2(cos(a), -sin(a), sin(a), cos(a));
  vec2 g = rot * p / u_cell;
  vec2 id = floor(g);
  vec2 f = fract(g) - 0.5;

  float h = hash(id);
  float h2 = hash(id + 7.3);

  float rim = smoothstep(0.35, 1.0, dist);
  float r = mix(u_rMin, u_rMax, rim) * (0.55 + 0.9 * h2);

  float aa = 1.2 / u_cell;
  float d = length(f);
  float m = 1.0 - smoothstep(r - aa, r + aa, d);

  vec3 col = h < 0.25 ? u_c1 : (h < 0.5 ? u_c2 : (h < 0.75 ? u_c3 : u_c4));
  gl_FragColor = vec4(col * m, m);
}
