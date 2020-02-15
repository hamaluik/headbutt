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

import glm.GLM;
using glm.Vec3;
using glm.Vec4;
using glm.Mat4;
using glm.Quat;
import headbutt.threed.Shape;
import haxe.ds.Vector;

/**
 A box is basically the same as a polyhedron, but with specifically 8 vertices which are at right angles
 from each other
**/
class Box implements Shape {
    var vertices: Vector<Vec3>;

    /**
     A 3-dimensional transform to apply to each vertex when calculating the simplex
    **/
    public var transform: Mat4;

    /**
     The centre of the box (derived from the transform)
    **/
    public var centre(get, never): Vec3;
    function get_centre(): Vec3 {
        return new Vec3(this.transform.r0c3, this.transform.r1c3, this.transform.r2c3);
    }

    /**
     Create a new box with the given size
     @param size the width, height, and length of the box
    **/
    public function new(size: Vec3) {
        this.transform = Mat4.identity(new Mat4());
        this.vertices = new Vector<Vec3>(8);
        this.vertices[0] = new Vec3();
        this.vertices[1] = new Vec3();
        this.vertices[2] = new Vec3();
        this.vertices[3] = new Vec3();
        this.vertices[4] = new Vec3();
        this.vertices[5] = new Vec3();
        this.vertices[6] = new Vec3();
        this.vertices[7] = new Vec3();
        resize(size);
    }

    /**
     Resize the box's local coordinates
     @param size the width, height, and length of the box
    **/
    public function resize(size: Vec3): Void {
        this.vertices[0].x = -0.5 * size.x;
        this.vertices[0].y = -0.5 * size.y;
        this.vertices[0].z = -0.5 * size.z;
        this.vertices[1].x =  0.5 * size.x;
        this.vertices[1].y = -0.5 * size.y;
        this.vertices[1].z = -0.5 * size.z;
        this.vertices[2].x =  0.5 * size.x;
        this.vertices[2].y =  0.5 * size.y;
        this.vertices[2].z = -0.5 * size.z;
        this.vertices[3].x = -0.5 * size.x;
        this.vertices[3].y =  0.5 * size.y;
        this.vertices[3].z = -0.5 * size.z;
        this.vertices[4].x = -0.5 * size.x;
        this.vertices[4].y = -0.5 * size.y;
        this.vertices[4].z =  0.5 * size.z;
        this.vertices[5].x =  0.5 * size.x;
        this.vertices[5].y = -0.5 * size.y;
        this.vertices[5].z =  0.5 * size.z;
        this.vertices[6].x =  0.5 * size.x;
        this.vertices[6].y =  0.5 * size.y;
        this.vertices[6].z =  0.5 * size.z;
        this.vertices[7].x = -0.5 * size.x;
        this.vertices[7].y =  0.5 * size.y;
        this.vertices[7].z =  0.5 * size.z;
    }

    /**
     Change the transform by supplying translation, rotation, and scale components
     @param position the new centre of the shape
     @param rotation the rotation of the shape
     @param scale the scale of the shape
    **/
    public function setTransform(position: Vec3, rotation: Quat, scale: Vec3): Void {
        this.transform = GLM.transform(position, rotation, scale, this.transform);
    }

    /**
       Given a direction in global coordinates, return the vertex (in global coordinates)
       that is the furthest in that direction
       @param direction the direction to check
       @return Vec3
    */
    public function support(direction: Vec3): Vec3 {
        var furthestDistance: Float = Math.NEGATIVE_INFINITY;
        var furthestVertex: Vec3 = new Vec3();

        var vi: Vec4 = new Vec4(0, 0, 0, 1);
        var vo: Vec4 = new Vec4();
        var vd: Vec3 = new Vec3();
        for(v in vertices) {
            vi.x = v.x;
            vi.y = v.y;
            vi.z = v.z;
            vo = Mat4.multVec(this.transform, vi, vo);
            vd.x = vo.x / vo.w;
            vd.y = vo.y / vo.w;
            vd.z = vo.z / vo.w;
            var distance: Float = Vec3.dot(vd, direction);
            if(distance > furthestDistance) {
                furthestDistance = distance;
                furthestVertex.x = vd.x;
                furthestVertex.y = vd.y;
                furthestVertex.z = vd.z;
            }
        }

        return furthestVertex;
    }
}