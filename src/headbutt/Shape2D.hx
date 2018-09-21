package headbutt;

import glm.Vec2;

interface Shape2D {
    public function support(direction:Vec2):Vec2;
}