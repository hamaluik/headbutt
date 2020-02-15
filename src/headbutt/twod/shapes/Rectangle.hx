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

import glm.Vec3;
import glm.Mat3;
using glm.Vec2;
import headbutt.twod.Shape;
import haxe.ds.Vector;

/**
 A rectangle is basically the same as a polygon, but with specifically 4 vertices which are at right angles from
 each other
**/
class Rectangle implements Shape {
    var vertices: Vector<Vec2>;

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
     Create a new rectangle with the given size
     @param size the width and height of the rectangle
    **/
    public function new(size: Vec2) {
        this.transform = Mat3.identity(new Mat3());
        this.vertices = new Vector<Vec2>(4);
        this.vertices[0] = new Vec2();
        this.vertices[1] = new Vec2();
        this.vertices[2] = new Vec2();
        this.vertices[3] = new Vec2();
        resize(size);
    }

    /**
     Resize the rectangle's local coordinates
     @param size the width and height of the rectangle
    **/
    public function resize(size: Vec2): Void {
        this.vertices[0].x = -0.5 * size.x;
        this.vertices[0].y = -0.5 * size.y;
        this.vertices[1].x =  0.5 * size.x;
        this.vertices[1].y = -0.5 * size.y;
        this.vertices[2].x =  0.5 * size.x;
        this.vertices[2].y =  0.5 * size.y;
        this.vertices[3].x = -0.5 * size.x;
        this.vertices[3].y =  0.5 * size.y;
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