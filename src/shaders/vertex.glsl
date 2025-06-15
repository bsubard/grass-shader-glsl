uniform float uTime;
uniform float uSpeed;
uniform float uHalfWidth;

varying vec3 vNormal1;
varying vec3 vNormal2;
varying float vElevation;
varying float vSideGradient;

void main() {
    vec3 localPosition = position;

    // Get direction to bend from instanceMatrix (Z axis)
    vec3 instanceX = normalize(vec3(0.0, 0.0, instanceMatrix[0].z));
    float bendStrength = 0.3;
    float topBendFactor = smoothstep(0.2, 1.0, position.y);

    // Bend geometry
    localPosition += instanceX * bendStrength * topBendFactor;

    // Apply instance transform
    vec4 worldPosition = instanceMatrix * vec4(localPosition, 1.0);

    // Project to screen
    vec4 viewPosition = viewMatrix * worldPosition;
    gl_Position = projectionMatrix * viewPosition;

    // ⚠️ Transform normal manually using instanceMatrix
    vec3 transformedNormal = normalize(mat3(instanceMatrix) * normal);
    vNormal1 = normalize(normalMatrix * normal); // Apply view rotation
    vNormal2 = normalize(normalMatrix * normal*-1.0); // Apply view rotation

    // Pass to fragment
    vElevation = position.y;
    vSideGradient = 1.0 - ((position.x + uHalfWidth) / (2.0 * uHalfWidth));
}
