package headbutt.twod.shapes;

using glm.Vec2;
import headbutt.twod.Shape;

class Line implements Shape {
    public var centre(get, never): Vec2;

    /**
       Start is in global coordinates
    */
    public var start: Vec2;

    /**
       End is in global coordinates
    */
    public var end: Vec2;

    public function new(start: Vec2, end: Vec2) {
        this.start = start;
        this.end = end;
    }

    function get_centre(): Vec2 {
        return new Vec2(
            (start.x + end.x) / 2,
            (start.y + end.y) / 2
        );
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