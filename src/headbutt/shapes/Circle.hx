package headbutt.shapes;

using glm.Vec2;
import headbutt.Shape2D;

class Circle implements Shape2D {
    public var centre(get, set):Vec2;
    private var _centre:Vec2;
    public var radius:Float;

    public function new(centre:Vec2, radius:Float) {
        this.centre = centre;
        this.radius = radius;
    }

    private function get_centre():Vec2 {
        return _centre;
    }

    private function set_centre(c:Vec2):Vec2 {
        return _centre = c;
    }

    public function support(direction:Vec2):Vec2 {
        var c:Vec2 = centre.copy(new Vec2());
        var d:Vec2 = direction.normalize(new Vec2());
        d.multiplyScalar(radius, d);
        c.addVec(d, c);
        return c;
    }
}