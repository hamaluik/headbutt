package headbutt.threed;

import glm.Vec3;

interface Shape {
    public var origin(get, set):Vec3;
    public function support(direction:Vec3):Vec3;
}