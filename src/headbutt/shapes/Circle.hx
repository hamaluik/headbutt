package headbutt.shapes;

using glm.Vec2;
import headbutt.Shape2D;

class Circle implements Shape2D {
    private var _origin: Vec2;
    public var origin(get, set): Vec2;
    public var radius: Float;

    /**
       Create a new circle
       @param origin The centre of the circle in global coordinates
       @param radius The radius of the circle
    */
    public function new(origin: Vec2, radius: Float) {
        this.origin = origin;
        this.radius = radius;
    }

    function get_origin(): Vec2 {
        return _origin;
    }

    function set_origin(origin: Vec2): Vec2 {
        return _origin = origin;
    }

    public function support(direction: Vec2): Vec2 {
        var c: Vec2 = origin.copy(new Vec2());
        var d: Vec2 = direction.normalize(new Vec2());
        d.multiplyScalar(radius, d);
        c.addVec(d, c);
        return c;
    }
}