package headbutt.shapes;

using glm.Vec2;
import headbutt.Shape2D;

class Polygon implements Shape2D {
    private var _origin: Vec2;
    /**
       The origin of the polygon in global coordinate space
    */
    public var origin(get, set): Vec2;

    /**
       The vertices in the local coordinate space
    */
    public var vertices:Array<Vec2>;

    /**
       Create a new polygon
       @param origin The location of the polygon in global coordinates
       @param vertices The locations of the vertices in local coordinates
    */
    public function new(origin: Vec2, vertices: Array<Vec2>) {
        this.origin = origin;
        this.vertices = vertices;
    }

    function get_origin(): Vec2 {
        return _origin;
    }

    function set_origin(origin: Vec2): Vec2 {
        return _origin = origin;
    }

    public function support(direction: Vec2): Vec2 {
        var furthestDistance: Float = Math.NEGATIVE_INFINITY;
        var furthestVertex: Vec2 = new Vec2(0, 0);

        var vo: Vec2 = new Vec2();
        for(v in vertices) {
            vo = v.addVec(origin, vo);
            var distance: Float = Vec2.dot(vo, direction);
            if(distance > furthestDistance) {
                furthestDistance = distance;
                furthestVertex = vo.copy(furthestVertex);
            }
        }

        return furthestVertex;
    }
}