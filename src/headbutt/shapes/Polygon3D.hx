package headbutt.shapes;

using glm.Vec3;
import headbutt.Shape3D;

class Polygon3D implements Shape3D {
    public var centre(get, set):Vec3;
    public var vertices:Array<Vec3>;

    public function new(?vertices:Array<Vec3>) {
        this.vertices = vertices;
    }

    private function get_centre():Vec3 {
        var c:Vec3 = new Vec3();
        var count:Float = 0.0;
        for(v in vertices) {
            c.addVec(v, c);
            count += 1.0;
        }
        c.multiplyScalar(1.0 / count, c);

        return c;
    }

    private function set_centre(c:Vec3):Vec3 {
        var diff:Vec3 = centre;
        c.subtractVec(diff, diff);
        for(vert in vertices) {
            vert.addVec(diff, vert);
        }
        return c;
    }

    public function support(direction:Vec3):Vec3 {
        var furthestDistance:Float = Math.NEGATIVE_INFINITY;
        var furthestVertex:Vec3 = null;

        for(v in vertices) {
            var distance:Float = Vec3.dot(v, direction);
            if(distance > furthestDistance) {
                furthestDistance = distance;
                furthestVertex = v;
            }
        }

        return furthestVertex;
    }
}