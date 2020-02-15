package headbutt.twod.shapes;

using glm.Vec2;
import glm.Mat3;
import glm.Vec3;
import headbutt.twod.TransformableShape;

class Polygon implements TransformableShape {
    private var _transform: Mat3;
    public var transform(get, set): Mat3;
    public var centre(get, never): Vec2;

    /**
       The vertices in the local coordinate space
    */
    public var vertices:Array<Vec2>;

    /**
       Create a new polygon
       @param vertices The locations of the vertices in local coordinates
    */
    public function new(vertices: Array<Vec2>) {
        this.transform = Mat3.identity(new Mat3());
        this.vertices = vertices;
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