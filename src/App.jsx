import { Canvas } from "@react-three/fiber";
import { GizmoHelper, GizmoViewport, OrbitControls,  } from "@react-three/drei";
import { Experience } from "./components/Experience";



function App() {

  return (
    <Canvas camera={{ position: [3, 3, 3], fov: 60 }}>
      <GizmoHelper>
        <GizmoViewport />
      </GizmoHelper>
      <axesHelper args={[5]} />

      <Experience/>
    </Canvas>
  );
}

export default App;
