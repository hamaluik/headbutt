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

/**
 A collection of points in 3D, which together define a **convex** solid
**/
class Polyhedron implements Shape {
    /**
       The vertices in the local coordinate space
    */
    public var vertices: Array<Vec3>;

    /**
     A 3-dimensional transform to apply to each vertex when calculating the simplex
    **/
    public var transform: Mat4;

    /**
     The centre of the polyhedron (derived from the transform)
    **/
    public var centre(get, never): Vec3;
    function get_centre(): Vec3 {
        return new Vec3(this.transform.r0c3, this.transform.r1c3, this.transform.r2c3);
    }

    /**
       Create a new polygon
       @param origin The location of the polygon in global coordinates
       @param vertices The locations of the vertices in local coordinates
    */
    public function new(vertices: Array<Vec3>) {
        this.transform = Mat4.identity(new Mat4());
        this.vertices = vertices;
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