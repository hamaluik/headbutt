package headbutt.threed.shapes;

using glm.Vec3;
import headbutt.threed.Shape;

class Sphere implements Shape {
    private var _origin: Vec3;
    public var origin(get, set): Vec3;
    public var radius: Float;

    /**
       Create a new sphere
       @param origin The centre of the sphere in global coordinates
       @param radius The radius of the sphere
    */
    public function new(origin: Vec3, radius: Float) {
        this.origin = origin;
        this.radius = radius;
    }

    function get_origin(): Vec3 {
        return _origin;
    }

    function set_origin(origin: Vec3): Vec3 {
        return _origin = origin;
    }

    public function support(direction: Vec3): Vec3 {
        var c: Vec3 = origin.copy(new Vec3());
        var d: Vec3 = direction.normalize(new Vec3());
        d.multiplyScalar(radius, d);
        c.addVec(d, c);
        return c;
    }
}