package headbutt.shapes;

using glm.Vec2;
import headbutt.Shape2D;

class Polygon2D implements Shape2D {
    public var offset(get, set):Vec2;
    private var _offset:Vec2;
    public var vertices:Array<Vec2>;

    public function new(?vertices:Array<Vec2>) {
        this.vertices = vertices;
    }

    private function get_offset():Vec2 {
        return _offset;
    }

    private function set_offset(c:Vec2):Vec2 {
        return _offset = c;
    }

    public function support(direction:Vec2):Vec2 {
        var furthestDistance:Float = Math.NEGATIVE_INFINITY;
        var furthestVertex:Vec2 = null;

        var vo:Vec2 = new Vec2();
        for(v in vertices) {
            vo = v.addVec(offset, vo);
            var distance:Float = Vec2.dot(vo, direction);
            if(distance > furthestDistance) {
                furthestDistance = distance;
                furthestVertex = vo.copy(furthestVertex);
            }
        }

        return furthestVertex;
    }
}