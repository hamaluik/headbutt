package headbutt.threed;

import glm.Vec3;

interface Shape {
    /**
       The origin / centre of the shape.
    */
    public var origin(get, set):Vec3;

    /**
       Given a direction in global coordinates, return the vertex (in global coordinates)
       that is the furthest in that direction
       @param direction 
       @return Vec3
    */
    public function support(direction:Vec3):Vec3;
}