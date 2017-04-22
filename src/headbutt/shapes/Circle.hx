package headbutt.shapes;

using glm.Vec2;
import headbutt.Shape2D;

class Circle implements Shape2D {
    public var centre:Vec2;
    public var radius:Float;

    public function new(centre:Vec2, radius:Float) {
        this.centre = centre;
        this.radius = radius;
    }

    public function center():Vec2 {
        return centre;
    }

    public function support(direction:Vec2):Vec2 {
        var c:Vec2 = centre.copy(new Vec2());
        var d:Vec2 = direction.normalize(new Vec2());
        d.multiplyScalar(radius, d);
        c.addVec(d, c);
        return c;
    }
}