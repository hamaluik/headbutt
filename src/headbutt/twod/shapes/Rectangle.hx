package headbutt.twod.shapes;

import glm.Vec3;
import glm.Mat3;
using glm.Vec2;
import headbutt.twod.TransformableShape;
import haxe.ds.Vector;

class Rectangle implements TransformableShape {
    private var _transform: Mat3;
    public var transform(get, set): Mat3;
    public var centre(get, never): Vec2;

    var vertices: Vector<Vec2>;

    public function new(halfsize: Vec2) {
        this.transform = Mat3.identity(new Mat3());
        this.vertices = new Vector<Vec2>(4);
        this.vertices[0] = new Vec2();
        this.vertices[1] = new Vec2();
        this.vertices[2] = new Vec2();
        this.vertices[3] = new Vec2();
        resize(halfsize);
    }

    function get_centre(): Vec2 {
        return new Vec2(this._transform.r0c2, this._transform.r1c2);
    }

    function get_transform(): Mat3 {
        return _transform;
    }

    function set_transform(t: Mat3): Mat3 {
        return _transform = t;
    }

    public function set_trs(position: Vec2, rotation: Float, scale: Vec2): Void {
        var c: Float = Math.cos(rotation);
        var s: Float = Math.sin(rotation);

        this._transform.r0c0 = scale.x * c;
        this._transform.r0c1 = -s;
        this._transform.r0c2 = position.x;

        this._transform.r1c0 = scale.x * s;
        this._transform.r1c1 = scale.y * c;
        this._transform.r1c2 = position.y;
        
        this._transform.r2c0 = 0;
        this._transform.r2c1 = 0;
        this._transform.r2c2 = 1;
    }

    public function resize(halfsize: Vec2): Void {
        this.vertices[0].x = -1 * halfsize.x;
        this.vertices[0].y = -1 * halfsize.y;
        this.vertices[1].x =  1 * halfsize.x;
        this.vertices[1].y = -1 * halfsize.y;
        this.vertices[2].x =  1 * halfsize.x;
        this.vertices[2].y =  1 * halfsize.y;
        this.vertices[3].x = -1 * halfsize.x;
        this.vertices[3].y =  1 * halfsize.y;
    }

    public function support(direction: Vec2): Vec2 {
        var furthestDistance: Float = Math.NEGATIVE_INFINITY;
        var furthestVertex: Vec2 = new Vec2();

        var vi: Vec3 = new Vec3(0, 0, 1);
        var vo: Vec3 = new Vec3();
        var vd: Vec2 = new Vec2();
        for(v in vertices) {
            vi.x = v.x;
            vi.y = v.y; 
            vo = Mat3.multVec(this._transform, vi, vo);
            vd.x = vo.x;
            vd.y = vo.y;
            var distance: Float = Vec2.dot(vd, direction);
            if(distance > furthestDistance) {
                furthestDistance = distance;
                furthestVertex.x = vo.x;
                furthestVertex.y = vo.y;
            }
        }

        return furthestVertex;
    }
}