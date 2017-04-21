package headbutt.twod;

import glm.Vec2;

interface Shape2D {
    public function center():Vec2;
    public function support(direction:Vec2):Vec2;
}