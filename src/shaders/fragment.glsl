uniform float uTime;
uniform vec3 uBaseColor;
uniform vec3 uTipColor;
varying float vElevation;

void main()
{
    // vec3 baseColor = vec3(0.05, 0.2, 0.01);
    // vec3 tipColor = vec3(0.5, 1.0, 0.1); // optional variation
    float gradient = smoothstep(0.0, 1.0, vElevation);
    vec3 finalColor = mix(uBaseColor, uTipColor, gradient);

    gl_FragColor = vec4(finalColor, 1.0);
}
