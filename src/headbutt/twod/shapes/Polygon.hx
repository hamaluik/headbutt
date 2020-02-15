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
import glm.Mat3;
import glm.Vec3;
import headbutt.twod.Shape;

/**
 A collection of points in 2D, which together define a **convex** solid
**/
class Polygon implements Shape {
    /**
       The vertices in the local coordinate space
    */
    public var vertices: Array<Vec2>;

    /**
     A 2-dimensional transform to apply to each vertex when calculating the simplex
    **/
    public var transform: Mat3;

    /**
     The centre of the polygon (derived from the transform)
    **/
    public var centre(get, never): Vec2;
    function get_centre(): Vec2 {
        return new Vec2(this.transform.r0c2, this.transform.r1c2);
    }

    /**
       Create a new polygon
       @param vertices The locations of the vertices in local coordinates
    */
    public function new(vertices: Array<Vec2>) {
        this.transform = Mat3.identity(new Mat3());
        this.vertices = vertices;
    }

    /**
     Change the transform by supplying translation, rotation, and scale components
     @param position the new centre of the shape
     @param rotation the rotation of the shape
     @param scale the scale of the shape
    **/
    public function setTransform(position: Vec2, rotation: Float, scale: Vec2): Void {
        var c: Float = Math.cos(rotation);
        var s: Float = Math.sin(rotation);

        this.transform.r0c0 = scale.x * c;
        this.transform.r0c1 = -s;
        this.transform.r0c2 = position.x;

        this.transform.r1c0 = scale.x * s;
        this.transform.r1c1 = scale.y * c;
        this.transform.r1c2 = position.y;
        
        this.transform.r2c0 = 0;
        this.transform.r2c1 = 0;
        this.transform.r2c2 = 1;
    }

    /**
       Given a direction in global coordinates, return the vertex (in global coordinates)
       that is the furthest in that direction
       @param direction the direction to find the support vertex in
       @return Vec2
    */
    public function support(direction: Vec2): Vec2 {
        var furthestDistance: Float = Math.NEGATIVE_INFINITY;
        var furthestVertex: Vec2 = new Vec2();

        var vi: Vec3 = new Vec3(0, 0, 1);
        var vo: Vec3 = new Vec3();
        var vd: Vec2 = new Vec2();
        for(v in vertices) {
            vi.x = v.x;
            vi.y = v.y;
            vo = Mat3.multVec(this.transform, vi, vo);
            vd.x = vo.x / vo.z;
            vd.y = vo.y / vo.z;
            var distance: Float = Vec2.dot(vd, direction);
            if(distance > furthestDistance) {
                furthestDistance = distance;
                furthestVertex.x = vd.x;
                furthestVertex.y = vd.y;
            }
        }

        return furthestVertex;
    }
}