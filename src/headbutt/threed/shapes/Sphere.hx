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

package headbutt.threed.shapes;

using glm.Vec3;
import headbutt.threed.Shape;

/**
 A 3D sphere
**/
class Sphere implements Shape {
    /**
     Where the sphere is located / the centre of it
    **/
    public var position: Vec3;

    /**
     How large the sphere is, half the diameter
    **/
    public var radius: Float;

    /**
     The centre of the sphere
    **/
    public var centre(get, never): Vec3;
    function get_centre(): Vec3 {
        return position;
    }

    /**
       Create a new sphere
       @param position The centre of the sphere in global coordinates
       @param radius The radius of the sphere
    */
    public function new(position: Vec3, radius: Float) {
        this.position = position;
        this.radius = radius;
    }

    /**
       Given a direction in global coordinates, return the vertex (in global coordinates)
       that is the furthest in that direction
       @param direction the direction to check
       @return Vec3
    */
    public function support(direction: Vec3): Vec3 {
        var c: Vec3 = position.copy(new Vec3());
        var d: Vec3 = direction.normalize(new Vec3());
        d.multiplyScalar(radius, d);
        c.addVec(d, c);
        return c;
    }
}