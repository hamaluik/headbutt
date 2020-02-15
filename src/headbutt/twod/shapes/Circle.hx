/*
 * Apache License, Version 2.0
 *
 * Copyright (c) 2020 Kenton Hamaluik
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 *     http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package headbutt.twod.shapes;

using glm.Vec2;
import headbutt.twod.Shape;

/**
 A circle has a centre and a radius
**/
class Circle implements Shape {
    /**
     Where the circle is located / the centre of it
    **/
    public var position: Vec2;

    /**
     How large the circle is, half the diameter
    **/
    public var radius: Float;

    /**
     The centre of the circle, in global coordinates
    **/
    public var centre(get, never): Vec2;
    function get_centre(): Vec2 {
        return position;
    }

    /**
       Create a new circle
       @param position The centre of the circle in global coordinates
       @param radius The radius of the circle
    */
    public function new(position: Vec2, radius: Float) {
        this.position = position;
        this.radius = radius;
    }

    /**
       Given a direction in global coordinates, return the vertex (in global coordinates)
       that is the furthest in that direction
       @param direction the direction to find the support vertex in
       @return Vec2
    */
    public function support(direction: Vec2): Vec2 {
        var c: Vec2 = position.copy(new Vec2());
        var d: Vec2 = direction.normalize(new Vec2());
        d.multiplyScalar(radius, d);
        c.addVec(d, c);
        return c;
    }
}