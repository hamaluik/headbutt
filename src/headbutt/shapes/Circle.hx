package headbutt.shapes;

using glm.Vec2;
import headbutt.Shape2D;

class Circle implements Shape2D {
    public var offset(get, set):Vec2;
    private var _offset:Vec2;

    public var radius:Float;

    public function new(radius:Float) {
        this.radius = radius;
        this.offset = new Vec2(0, 0);
    }

    private function get_offset():Vec2 {
        return _offset;
    }

    private function set_offset(c:Vec2):Vec2 {
        return _offset = c;
    }

    public function support(direction:Vec2):Vec2 {
        var c:Vec2 = offset.copy(new Vec2());
        var d:Vec2 = direction.normalize(new Vec2());
        d.multiplyScalar(radius, d);
        c.addVec(d, c);
        return c;
    }
}