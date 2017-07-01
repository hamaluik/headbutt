package headbutt.shapes;

using glm.Vec3;
import headbutt.Shape3D;

class Sphere implements Shape3D {
    public var centre(get, set):Vec3;
    private var _centre:Vec3;
    public var radius:Float;

    public function new(centre:Vec3, radius:Float) {
        this.centre = centre;
        this.radius = radius;
    }

    private function get_centre():Vec3 {
        return _centre;
    }

    private function set_centre(c:Vec3):Vec3 {
        return _centre = c;
    }

    public function support(direction:Vec3):Vec3 {
        var c:Vec3 = centre.copy(new Vec3());
        var d:Vec3 = direction.normalize(new Vec3());
        d.multiplyScalar(radius, d);
        c.addVec(d, c);
        return c;
    }
}