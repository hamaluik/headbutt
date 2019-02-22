package headbutt.threed.shapes;

using glm.Vec3;
import headbutt.threed.Shape;

// TODO: make it implement a TransformableShape!
class Sphere implements Shape {
    public var position: Vec3;
    public var centre(get, never):Vec3;
    public var radius: Float;

    /**
       Create a new sphere
       @param position The centre of the sphere in global coordinates
       @param radius The radius of the sphere
    */
    public function new(position: Vec3, radius: Float) {
        this.position = position;
        this.radius = radius;
    }

    function get_centre(): Vec3 {
        return position;
    }

    // TODO: how to calculate a support for a transformed sphere?
    // Do we inverse transform the direction?
    public function support(direction: Vec3): Vec3 {
        var c: Vec3 = position.copy(new Vec3());
        var d: Vec3 = direction.normalize(new Vec3());
        d.multiplyScalar(radius, d);
        c.addVec(d, c);
        return c;
    }
}