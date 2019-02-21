package headbutt.threed.shapes;

using glm.Vec3;
import headbutt.threed.Shape;
import haxe.ds.Vector;

class Box implements Shape {
    private var _origin: Vec3;
    public var origin(get, set): Vec3;

    var vertices: Vector<Vec3>;

    public function new(origin: Vec3, halfsize: Vec3) {
        this.origin = origin;
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

    function get_origin(): Vec3 {
        return _origin;
    }

    function set_origin(origin: Vec3): Vec3 {
        return _origin = origin;
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

    public function support(direction: Vec3): Vec3 {
        var furthestDistance: Float = Math.NEGATIVE_INFINITY;
        var furthestVertex: Vec3 = new Vec3();

        var vo: Vec3 = new Vec3();
        for(v in vertices) {
            vo = v.addVec(origin, vo);
            var distance: Float = Vec3.dot(vo, direction);
            if(distance > furthestDistance) {
                furthestDistance = distance;
                furthestVertex = vo.copy(furthestVertex);
            }
        }

        return furthestVertex;
    }
}