package headbutt.shapes;

using glm.Vec2;
import headbutt.Shape2D;
import haxe.ds.Vector;

class Rectangle implements Shape2D {
    private var _origin: Vec2;
    public var origin(get, set): Vec2;

    var vertices: Vector<Vec2>;

    public function new(origin: Vec2, halfsize: Vec2) {
        this.origin = origin;
        this.vertices = new Vector<Vec2>(4);
        this.vertices[0] = new Vec2();
        this.vertices[1] = new Vec2();
        this.vertices[2] = new Vec2();
        this.vertices[3] = new Vec2();
        resize(halfsize);
    }

    function get_origin(): Vec2 {
        return _origin;
    }

    function set_origin(origin: Vec2): Vec2 {
        return _origin = origin;
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