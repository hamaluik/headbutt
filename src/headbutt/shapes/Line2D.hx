package headbutt.shapes;

using glm.Vec2;
import headbutt.Shape2D;

class Line2D implements Shape2D {
    /**
       Start is in global coordinates
    */
    public var start: Vec2;

    /**
       End is in global coordinates
    */
    public var end: Vec2;

    private var _origin: Vec2 = new Vec2(0, 0);
    public var origin(get, set): Vec2;

    public function new(start: Vec2, end: Vec2) {
        this.start = start;
        this.end = end;
    }

    function get_origin(): Vec2 {
        _origin.x = (start.x + end.x) / 2;
        _origin.y = (start.y + end.y) / 2;
        return _origin;
    }

    function set_origin(origin: Vec2): Vec2 {
        var dx: Float = origin.x - _origin.x;
        var dy: Float = origin.y - _origin.y;
        start.x += dx;
        end.x += dx;
        start.y += dy;
        end.y += dy;

        return _origin = origin;
    }

    public function support(direction: Vec2): Vec2 {
        if(Vec2.dot(start, direction) > Vec2.dot(end, direction)) {
            return start;
        }
        else {
            return end;
        }
    }
}