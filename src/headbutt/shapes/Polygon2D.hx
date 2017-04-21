package headbutt.shapes;

using glm.Vec2;
import headbutt.twod.Shape2D;

class Polygon2D implements Shape2D {
    public var vertices:Array<Vec2>;

    public function new(?vertices:Array<Vec2>) {
        this.vertices = vertices;
    }

    public function center():Vec2 {
        var c:Vec2 = new Vec2();
        var count:Float = 0.0;
        for(v in vertices) {
            c.addVec(v, c);
            count += 1.0;
        }
        c.multiplyScalar(1.0 / count, c);
        return c;
    }

    public function support(direction:Vec2):Vec2 {
        var furthestDistance:Float = Math.NEGATIVE_INFINITY;
        var furthestVertex:Vec2 = null;

        for(v in vertices) {
            var distance:Float = Vec2.dot(v, direction);
            if(distance > furthestDistance) {
                furthestDistance = distance;
                furthestVertex = v;
            }
        }

        return furthestVertex;
    }
}