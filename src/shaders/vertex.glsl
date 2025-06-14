// uniform mat4 projectionMatrix; // camera projection into clip space (perspective, orthographic, etc.)
// uniform mat4 viewMatrix;    // camera transformations (viewing angle, position, etc.)
// uniform mat4 modelMatrix; //transformations relative to the mesh (rotation, position, scale)

uniform float uTime;
uniform float uSpeed;

varying float vElevation;

void main() {
    // Local position of the vertex
    vec3 localPosition = position;

    // Extract local X-axis from instance matrix (direction to bend)
    vec3 instanceX = normalize(vec3(instanceMatrix[0].x, instanceMatrix[0].y, instanceMatrix[0].z));


    // Bend strength (constant or time-animated)
    float bendStrength = 0.2;

    // Smooth interpolation from 0 (bottom) to 1 (top)
    float topBendFactor = smoothstep(0.0, 1.0, position.y);

    // Final displacement
    localPosition += instanceX * bendStrength * topBendFactor;

    // Apply instance transform
    vec4 modelPosition = instanceMatrix * vec4(localPosition, 1.0);

    // Project to clip space
    vec4 viewPosition = viewMatrix * modelPosition;
    gl_Position = projectionMatrix * viewPosition;

    // Pass elevation for coloring
    vElevation = position.y;
}
