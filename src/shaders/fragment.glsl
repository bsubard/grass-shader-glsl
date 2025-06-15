uniform float uTime;
uniform vec3 uBaseColor;
uniform vec3 uTipColor;


varying float vElevation;
varying vec3 vNormal1;
varying vec3 vNormal2;
varying float vSideGradient;

vec3 ambientLight(){
    return vec3(0.0,0.0,0.0);
}

void main()
{
    float gradient = smoothstep(0.0, 1.0, vElevation);
    float sideGradient = smoothstep(0.0, 1.0, vSideGradient);
    vec3 finalColor = mix(uBaseColor, uTipColor, gradient);
    vec3 normalFinalColor = mix(vNormal2, vNormal1, sideGradient);
    gl_FragColor = vec4(finalColor, 1.0);
}
