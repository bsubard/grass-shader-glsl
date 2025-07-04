// src/components/Plane.jsx
import { RigidBody } from "@react-three/rapier";
import React from "react";

const Plane = () => {
  return (
    <RigidBody type="fixed" colliders="hull">
      <mesh
        rotation-x={-Math.PI / 2}
        position={[0, 0, 0]}
        receiveShadow
      >
        <planeGeometry args={[100, 100]} />
        <meshStandardMaterial color="#000000" />
      </mesh>
    </RigidBody>
  );
};

export default Plane;
