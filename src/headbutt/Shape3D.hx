package headbutt;

import glm.Vec3;

interface Shape3D {
    public var centre(get, set):Vec3;
    public function support(direction:Vec3):Vec3;
}