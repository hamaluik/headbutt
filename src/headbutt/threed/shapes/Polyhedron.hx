package headbutt.threed.shapes;

import glm.GLM;
using glm.Vec3;
using glm.Vec4;
using glm.Mat4;
using glm.Quat;
import headbutt.threed.TransformableShape;

class Polyhedron implements TransformableShape {
    private var _transform: Mat4;
    public var transform(get, set): Mat4;
    public var centre(get, never): Vec3;

    /**
       The vertices in the local coordinate space
    */
    public var vertices:Array<Vec3>;

    /**
       Create a new polygon
       @param origin The location of the polygon in global coordinates
       @param vertices The locations of the vertices in local coordinates
    */
    public function new(vertices: Array<Vec3>) {
        this.transform = Mat4.identity(new Mat4());
        this.vertices = vertices;
    }

    function get_centre(): Vec3 {
        return new Vec3(this._transform.r0c2, this._transform.r1c2);
    }

    function get_transform(): Mat4 {
        return _transform;
    }

    function set_transform(t: Mat4): Mat4 {
        return _transform = t;
    }

    public function set_trs(position: Vec3, rotation: Quat, scale: Vec3): Void {
        this._transform = GLM.transform(position, rotation, scale, this._transform);
    }

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
            vo = Mat4.multVec(this._transform, vi, vo);
            vd.x = vo.x;
            vd.y = vo.y;
            vd.z = vo.z;
            var distance: Float = Vec3.dot(vd, direction);
            if(distance > furthestDistance) {
                furthestDistance = distance;
                furthestVertex.x = vo.x;
                furthestVertex.y = vo.y;
                furthestVertex.z = vo.z;
            }
        }

        return furthestVertex;
    }
}