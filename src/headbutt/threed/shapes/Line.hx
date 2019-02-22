package headbutt.threed.shapes;

using glm.Vec3;
import headbutt.threed.Shape;

class Line implements Shape {
    public var centre(get, never):Vec3;

    /**
       Start is in global coordinates
    */
    public var start: Vec3;

    /**
       End is in global coordinates
    */
    public var end: Vec3;

    public function new(start: Vec3, end: Vec3) {
        this.start = start;
        this.end = end;
    }

    function get_centre(): Vec3 {
        return new Vec3(
            (start.x + end.x) / 2,
            (start.y + end.y) / 2,
            (start.z + end.z) / 2
        );
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