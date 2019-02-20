package headbutt.twod;

import glm.Vec2;

interface Shape {
    public var origin(get, set): Vec2;
    public function support(direction: Vec2): Vec2;
}