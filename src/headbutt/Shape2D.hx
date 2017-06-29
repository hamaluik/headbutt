package headbutt;

import glm.Vec2;

interface Shape2D {
    public var centre(get, set):Vec2;
    public function support(direction:Vec2):Vec2;
}