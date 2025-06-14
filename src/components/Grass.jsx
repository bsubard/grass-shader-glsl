import { useRef, useEffect, useMemo } from "react";
import * as THREE from "three";
import grassVertexShader from "../shaders/vertex.glsl";
import grassFragmentShader from "../shaders/fragment.glsl";
import { useControls } from "leva";
import { useFrame } from "@react-three/fiber";

export const GrassBlade = () => {
  const meshRef = useRef();

  // Load texture
  const textureLoader = new THREE.TextureLoader();
  const flagTexture = textureLoader.load("./textures/flag.jpg");

  // Create plane geometry
  const planeGeometry = useMemo(() => {
    const geom = new THREE.PlaneGeometry(2, 2, 64, 64);
    return geom;
  }, []);

  // Define leva controls
  const { freqX, freqY, speed } = useControls("Grass Frequency", {
    freqX: { value: 8, min: 0, max: 20, step: 0.1 },
    freqY: { value: 20, min: 0, max: 20, step: 0.1 },
    speed: { value: 5, min: 0, max: 20, step: 0.1 },
  });

  // Initialize uniforms once
  const uniforms = useMemo(() => ({
    uFrequency: { value: new THREE.Vector2(freqX, freqY) },
    uTime: { value: 0 },
    uSpeed: { value: speed },
    uColor: { value: new THREE.Color('gray')},
    uTexture: { value: flagTexture },
  }), []);

  // Update the uniform when leva values change
  useEffect(() => {
    uniforms.uFrequency.value.set(freqX, freqY);
    uniforms.uSpeed.value = speed;
  }, [freqX, freqY, speed]);

  // Update the uniform every frame
  useFrame((state, delta) => {
    uniforms.uTime.value += delta;

  });


  return (
    <mesh
      ref={meshRef}
      rotation={[0, Math.PI, 0]}
      position={[2, 1, 1]}
      geometry={planeGeometry}
      castShadow
    >
      <shaderMaterial
        vertexShader={grassVertexShader}
        fragmentShader={grassFragmentShader}
        uniforms={uniforms}
      />
    </mesh>
  );
};
