// uniform mat4 projectionMatrix; // camera projection into clip space (perspective, orthographic, etc.)
// uniform mat4 viewMatrix;    // camera transformations (viewing angle, position, etc.)
// uniform mat4 modelMatrix; //transformations relative to the mesh (rotation, position, scale)

uniform vec2 uFrequency; //frequency of the wave
uniform float uTime;
uniform float uSpeed;

// attribute vec3 position; //each vertex position in the mesh
// attribute vec2 uv;

varying vec2 vUv;
varying float vElevation;


void main()
{
   vec4 modelPosition = modelMatrix * vec4(position, 1.0);
   float elevation = sin(uFrequency.x * modelPosition.x + uTime * uSpeed) * 0.1;
    modelPosition.z += elevation; // Apply a sine wave to the z-coordinate based on the x-coordinate and frequency
   vec4 viewPosition = viewMatrix * modelPosition;
   vec4 projectedPosition = projectionMatrix * viewPosition;
   gl_Position = projectedPosition;

   vUv = uv;
   vElevation = elevation;

}