package headbutt.threed.shapes;

import glm.GLM;
using glm.Vec3;
using glm.Vec4;
using glm.Mat4;
using glm.Quat;
import headbutt.threed.TransformableShape;
import haxe.ds.Vector;

class Box implements TransformableShape {
    private var _transform: Mat4;
    public var transform(get, set): Mat4;
    public var centre(get, never): Vec3;

    var vertices: Vector<Vec3>;

    public function new(halfsize: Vec3) {
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
        resize(halfsize);
    }

    public function resize(halfsize: Vec3): Void {
        this.vertices[0].x = -1 * halfsize.x;
        this.vertices[0].y = -1 * halfsize.y;
        this.vertices[0].z = -1 * halfsize.z;
        this.vertices[1].x =  1 * halfsize.x;
        this.vertices[1].y = -1 * halfsize.y;
        this.vertices[1].z = -1 * halfsize.z;
        this.vertices[2].x =  1 * halfsize.x;
        this.vertices[2].y =  1 * halfsize.y;
        this.vertices[2].z = -1 * halfsize.z;
        this.vertices[3].x = -1 * halfsize.x;
        this.vertices[3].y =  1 * halfsize.y;
        this.vertices[3].z = -1 * halfsize.z;
        this.vertices[4].x = -1 * halfsize.x;
        this.vertices[4].y = -1 * halfsize.y;
        this.vertices[4].z =  1 * halfsize.z;
        this.vertices[5].x =  1 * halfsize.x;
        this.vertices[5].y = -1 * halfsize.y;
        this.vertices[5].z =  1 * halfsize.z;
        this.vertices[6].x =  1 * halfsize.x;
        this.vertices[6].y =  1 * halfsize.y;
        this.vertices[6].z =  1 * halfsize.z;
        this.vertices[7].x = -1 * halfsize.x;
        this.vertices[7].y =  1 * halfsize.y;
        this.vertices[7].z =  1 * halfsize.z;
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