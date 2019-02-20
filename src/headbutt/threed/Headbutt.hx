package headbutt.threed;

using glm.Vec3;

private enum EvolveResult {
    NoIntersection;
    FoundIntersection;
    StillEvolving;
}

class Headbutt {
    private var vertices:Array<Vec3>;
    private var direction:Vec3;
    private var shapeA:Shape;
    private var shapeB:Shape;

    public var maxIterations:Int = 20;

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
                direction = shapeB.origin - shapeA.origin;
            }
            case 1: {
                // flip the direction
                direction *= -1;
            }
            case 2: {
                // line ab is the line formed by the first two vertices
                var ab:Vec3 = vertices[1] - vertices[0];
                // line a0 is the line from the first vertex to the origin
                var a0:Vec3 = vertices[0] * -1;

                // use the triple-cross-product to calculate a direction perpendicular
                // to line ab in the direction of the origin
                var tmp:Vec3 = ab.cross(a0, new Vec3());
                direction = tmp.cross(ab, direction);
            }
            case 3: {
                var ac:Vec3 = vertices[2] - vertices[0];
                var ab:Vec3 = vertices[1] - vertices[0];
                direction = ac.cross(ab, new Vec3());

                // ensure it points toward the origin
                var a0:Vec3 = vertices[0] * -1;
                if(direction.dot(a0) < 0) direction *= -1;
            }
            case 4: {
                // ascii representation of our simplex at this point
                /*
                                           [D]
                                          ,|,
                                        ,7``\'VA,
                                      ,7`   |, `'VA,
                                    ,7`     `\    `'VA,
                                  ,7`        |,      `'VA,
                                ,7`          `\         `'VA,
                              ,7`             |,           `'VA,
                            ,7`               `\       ,..ooOOTK` [C]
                          ,7`                  |,.ooOOT''`    AV
                        ,7`            ,..ooOOT`\`           /7
                      ,7`      ,..ooOOT''`      |,          AV
                     ,T,..ooOOT''`              `\         /7
                [A] `'TTs.,                      |,       AV
                         `'TTs.,                 `\      /7
                              `'TTs.,             |,    AV
                                   `'TTs.,        `\   /7
                                        `'TTs.,    |, AV
                                             `'TTs.,\/7
                                                  `'T`
                                                    [B]
                */

                // calculate the three edges of interest
                var da = vertices[3] - vertices[0];
                var db = vertices[3] - vertices[1];
                var dc = vertices[3] - vertices[2];

                // and the direction to the origin
                var d0 = vertices[3] * -1;

                // check triangles a-b-d, b-c-d, and c-a-d
                var abdNorm:Vec3 = da.cross(db, new Vec3());
                var bcdNorm:Vec3 = db.cross(dc, new Vec3());
                var cadNorm:Vec3 = dc.cross(da, new Vec3());

                if(abdNorm.dot(d0) > 0) {
                    // the origin is on the outside of triangle a-b-d
                    // eliminate c!
                    vertices.remove(vertices[2]);
                    direction = abdNorm;
                }
                else if(bcdNorm.dot(d0) > 0) {
                    // the origin is on the outside of triangle bcd
                    // eliminate a!
                    vertices.remove(vertices[0]);
                    direction = bcdNorm;
                }
                else if(cadNorm.dot(d0) > 0) {
                    // the origin is on the outside of triangle cad
                    // eliminate b!
                    vertices.remove(vertices[1]);
                    direction = cadNorm;
                }
                else {
                    // the origin is inside all of the triangles!
                    return EvolveResult.FoundIntersection;
                }
            }
            case _: throw 'Can\'t have simplex with ${vertices.length} verts!';
        }

        return addSupport(direction)
            ? EvolveResult.StillEvolving
            : EvolveResult.NoIntersection;
    }

    public function test(shapeA:Shape, shapeB:Shape):Bool {
        // reset everything
        this.vertices = new Array<Vec3>();
        this.shapeA = shapeA;
        this.shapeB = shapeB;

        // do the actual test
        var result:EvolveResult = EvolveResult.StillEvolving;
        var iterations:Int = 0;
        while(iterations < maxIterations && result == EvolveResult.StillEvolving) {
            result = evolveSimplex();
            iterations++;
        }

        return result == EvolveResult.FoundIntersection;
    }
}