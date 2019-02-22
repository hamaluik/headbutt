package headbutt.twod;

import glm.Vec2;

interface Shape {
    public var centre(get, never): Vec2;

    /**
       Given a direction in global coordinates, return the vertex (in global coordinates)
       that is the furthest in that direction
       @param direction 
       @return Vec2
    */
    public function support(direction: Vec2): Vec2;
}