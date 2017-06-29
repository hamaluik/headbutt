package headbutt;

using glm.Vec3;

class Headbutt3D {
    private var vertices:Array<Vec3>;
    private var direction:Vec3;
    private var shapeA:Shape3D;
    private var shapeB:Shape3D;

    public function new() {}

    private function calculateSupport(direction:Vec3):Vec3 {
        var oppositeDirection:Vec3 = direction.multiplyScalar(-1, new Vec3());
        var newVertex:Vec3 = shapeA.support(direction).copy(new Vec3());
        newVertex.subtractVec(shapeB.support(oppositeDirection), newVertex);
        return newVertex;
    }

    private function addSupport(direction:Vec3):Bool {
        var newVertex:Vec3 = calculateSupport(direction);
        vertices.push(newVertex);
        return Vec3.dot(direction, newVertex) >= 0;
    }

    private function evolveSimplex():EvolveResult {
        switch(vertices.length) {
            case 0: {
                direction = shapeB.centre - shapeA.centre;
            }
            case 1: {
                // flip the direction
                direction *= -1;
            }
            case 2: {
                var b:Vec3 = vertices[1];
                var c:Vec3 = vertices[0];
                
                // line cb is the line formed by the first two vertices
                var cb:Vec3 = b - c;
                // line c0 is the line from the first vertex to the origin
                var c0:Vec3 = c * -1;

                // use the triple-cross-product to calculate a direction perpendicular
                // to line cb in the direction of the origin
                //direction = tripleProduct(cb, c0, cb);
                var tmp:Vec3 = cb.cross(c0, new Vec3());
                direction = tmp.cross(cb, direction);
            }
            case 3: {
                var l31:Vec3 = vertices[2] - vertices[0];
                var l21:Vec3 = vertices[1] - vertices[0];
                direction = l31.cross(l21, new Vec3());
            }
            case 4: {
                // calculate if the simplex contains the origin
            }
            case _: throw 'Can\'t have simplex with ${vertices.length} verts!';
        }

        return addSupport(direction)
            ? EvolveResult.StillEvolving
            : EvolveResult.NoIntersection;
    }

    public function test(shapeA:Shape3D, shapeB:Shape3D):Bool {
        // reset everything
        this.vertices = new Array<Vec3>();
        this.shapeA = shapeA;
        this.shapeB = shapeB;

        // do the actual test
        var result:EvolveResult = EvolveResult.StillEvolving;
        while(result == EvolveResult.StillEvolving) {
            result = evolveSimplex();
        }
        return result == EvolveResult.FoundIntersection;
    }
}