package headbutt.twod;

import glm.Vec2;

interface Shape {
    /**
       The origin / centre of the shape.
    */
    public var origin(get, set): Vec2;

    /**
       Given a direction in global coordinates, return the vertex (in global coordinates)
       that is the furthest in that direction
       @param direction 
       @return Vec2
    */
    public function support(direction: Vec2): Vec2;
}