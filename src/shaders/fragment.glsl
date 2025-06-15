uniform float uTime;
uniform vec3 uBaseColor;
uniform vec3 uTipColor;

varying float vElevation;
varying float vSideGradient;
varying vec3 vNormal;
varying vec3 vFakeNormal;

vec3 directionalLight(vec3 lightColor, float lightIntensity, vec3 normal, vec3 lightPosition){
    vec3 lightDirection = normalize(lightPosition);

    //Shading
    float shading = dot(normal, lightDirection);
    return vec3(shading);
}
vec3 ambientLight(vec3 lightColor, float lightIntensity)
{
    return lightColor * lightIntensity;
}



void main()
{


    float gradient = smoothstep(0.5, 1.0, vElevation);
    float sideGradient = smoothstep(0.2, 1.0, vSideGradient);
    vec3 finalColor = mix(uBaseColor, uTipColor, gradient);

    vec3 light = vec3(0.0);
    light += ambientLight(vec3(1.0), 0.4);
    light += directionalLight(vec3(0.1,0.1,0.0), 1.6, vFakeNormal, vec3(1.0)) * 0.5;

    finalColor *= light;

    gl_FragColor = vec4(finalColor, 1.0);
}
