package headbutt.shapes;

using glm.Vec3;
import headbutt.Shape3D;

class ConvexPolygon3D implements Shape3D {
    private var _origin: Vec3;
    /**
       The origin of the polygon in global coordinate space
    */
    public var origin(get, set): Vec3;

    /**
       The vertices in the local coordinate space
    */
    public var vertices:Array<Vec3>;

    /**
       Create a new polygon
       @param origin The location of the polygon in global coordinates
       @param vertices The locations of the vertices in local coordinates
    */
    public function new(origin: Vec3, vertices: Array<Vec3>) {
        this.origin = origin;
        this.vertices = vertices;
    }

    function get_origin(): Vec3 {
        return _origin;
    }

    function set_origin(origin: Vec3): Vec3 {
        return _origin = origin;
    }

    public function support(direction: Vec3): Vec3 {
        var furthestDistance: Float = Math.NEGATIVE_INFINITY;
        var furthestVertex: Vec3 = new Vec3(0, 0, 0);

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