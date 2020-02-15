package headbutt.threed;

import glm.Mat4;
import glm.Vec3;
import glm.Quat;

interface TransformableShape extends Shape {
    public var transform(get, set): Mat4;
    public function set_trs(position: Vec3, rotation: Quat, scale: Vec3): Void;
}