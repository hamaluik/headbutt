package headbutt.threed.shapes;

using glm.Vec3;
import headbutt.threed.Shape;

class Line implements Shape {
    /**
       Start is in global coordinates
    */
    public var start: Vec3;

    /**
       End is in global coordinates
    */
    public var end: Vec3;

    private var _origin: Vec3 = new Vec3(0, 0);
    public var origin(get, set): Vec3;

    public function new(start: Vec3, end: Vec3) {
        this.start = start;
        this.end = end;
    }

    function get_origin(): Vec3 {
        _origin.x = (start.x + end.x) / 2;
        _origin.y = (start.y + end.y) / 2;
        return _origin;
    }

    function set_origin(origin: Vec3): Vec3 {
        var dx: Float = origin.x - _origin.x;
        var dy: Float = origin.y - _origin.y;
        start.x += dx;
        end.x += dx;
        start.y += dy;
        end.y += dy;

        return _origin = origin;
    }

    public function support(direction: Vec3): Vec3 {
        if(Vec3.dot(start, direction) > Vec3.dot(end, direction)) {
            return start;
        }
        else {
            return end;
        }
    }
}