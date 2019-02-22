package headbutt.twod;

import glm.Mat3;
import glm.Vec2;

interface TransformableShape extends Shape {
    public var transform(get, set): Mat3;
    public function set_trs(position: Vec2, rotation: Float, Scale: Vec2): Void;
}