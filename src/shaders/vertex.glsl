uniform float uTime;
uniform float uSpeed;
uniform float uHalfWidth;

varying float vElevation;
varying float vSideGradient;
varying vec3 vNormal;
varying vec3 vFakeNormal;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

mat3 rotationY(float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return mat3(
         c, 0.0, -s,
         0.0, 1.0, 0.0,
         s, 0.0,  c
    );
}

float bezier(float t, float p1) {
  float invT = 1.0 - t;
  return invT * invT * 0.0 + 2.0 * invT * t * p1 + t * t * 1.0;
}


void main() {
    vec3 localPosition = position;

    // ===== BEND FIRST in local Z-axis =====
vec3 instanceZ = normalize(vec3(0.0, 0.0, instanceMatrix[0].z)); // bend direction in local space

float hash = rand(vec2(instanceMatrix[3].x, instanceMatrix[3].z)); // use position seed
float bendStrength = mix(0.3, 0.6, hash); // increase strength range
float bendStart = 0.2; // start bending at 20% height
float t = clamp((position.y / 2.0 - bendStart) / (1.0 - bendStart), 0.0, 1.0); // shift bend start
float topBendFactor = bezier(t, 0.1); // more curvature using bezier



// ===== Gentle sway (local) =====
    float gentleSway = sin(uTime * uSpeed * 0.8 + hash * 10.0) * 0.1;
    vec3 gentleDir = normalize(vec3(1.0, 0.0, 1.0));
    vec3 gentleOffset = gentleDir * gentleSway * t;

    // ===== Strong wind wave sway (global) =====
    vec3 worldPos = (instanceMatrix * vec4(position, 1.0)).xyz;
    float wave = sin(dot(worldPos.xz, vec2(0.7, 0.7)) * 0.5 + uTime * uSpeed * 0.5);
    float strongWind = wave * 0.6;
    vec3 strongDir = normalize(vec3(0.0, 0.0, 1.0)); // major wind direction
    float y = position.y * 1.0;
    vec3 strongOffset = strongDir * strongWind * pow(y,2.0);

    // Combine all bending
    localPosition += instanceZ * bendStrength * topBendFactor;
    localPosition += gentleOffset;
    localPosition += strongOffset;

// ===== BILLBOARDING: ROTATE TOWARD CAMERA AFTER BENDING =====
vec3 camPos = inverse(viewMatrix)[3].xyz;
vec3 bladeWorldPos = instanceMatrix[3].xyz;
vec2 toCamera2D = normalize(camPos.xz - bladeWorldPos.xz);
float angleToCamera = atan(toCamera2D.y, toCamera2D.x); // atan(y, x)

mat3 billboardRot = rotationY(angleToCamera);
localPosition = billboardRot * localPosition;





    // Project to screen
    vec4 worldPosition = instanceMatrix * vec4(localPosition, 1.0);
    vec4 viewPosition = viewMatrix * worldPosition;
    gl_Position = projectionMatrix * viewPosition;


    // Pass to fragment
    vElevation = position.y;
    vSideGradient = 1.0 - ((position.x + uHalfWidth) / (2.0 * uHalfWidth));

     // ---- FAKE NORMAL BASED ON CURVE ----
    // Map sideGradient: 1 → -1, 0.5 → 0, 0 → +1
    float x = (0.5 - vSideGradient) * 2.0; // -1 to 1

    // Make a curved normal
     mat3 normalMatrix = mat3(instanceMatrix); // drop translation
    vec3 fakeNormal = normalize(vec3(x, 1.0, 0.0)); // Curve only in x direction
    vFakeNormal = normalize(normalMatrix * fakeNormal);

}
