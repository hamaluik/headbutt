package headbutt;

import glm.Vec3;
using glm.Vec2;
import headbutt.Shape2D;

enum EvolveResult {
    NoIntersection;
    FoundIntersection;
    StillEvolving;
}

enum PolygonWinding {
    Clockwise;
    CounterClockwise;
}

class Edge {
    public var distance:Float;
    public var normal:Vec2;
    public var index:Int;

    public function new(distance:Float, normal:Vec2, index:Int) {
        this.distance = distance;
        this.normal = normal;
        this.index = index;
    }
}

class Headbutt2D {
    private var vertices:Array<Vec2>;
    private var direction:Vec2;
    private var shapeA:Shape2D;
    private var shapeB:Shape2D;

    public function new() {}

    private function calculateSupport(direction:Vec2):Vec2 {
        var oppositeDirection:Vec2 = direction.multiplyScalar(-1, new Vec2());
        var newVertex:Vec2 = shapeA.support(direction).copy(new Vec2());
        newVertex.subtractVec(shapeB.support(oppositeDirection), newVertex);
        return newVertex;
    }

    private function addSupport(direction:Vec2):Bool {
        var newVertex:Vec2 = calculateSupport(direction);
        vertices.push(newVertex);
        return Vec2.dot(direction, newVertex) >= 0;
    }

    function tripleProduct(a:Vec2, b:Vec2, c:Vec2):Vec2 {
        var A:Vec3 = new Vec3(a.x, a.y, 0);
        var B:Vec3 = new Vec3(b.x, b.y, 0);
        var C:Vec3 = new Vec3(c.x, c.y, 0);

        var first:Vec3 = Vec3.cross(A, B, new Vec3());
        var second:Vec3 = Vec3.cross(first, C, new Vec3());

        return new Vec2(second.x, second.y);
    }

    private function evolveSimplex():EvolveResult {
        switch(vertices.length) {
            case 0: {
                direction = shapeB.center() - shapeA.center();
            }
            case 1: {
                // flip the direction
                direction *= -1;
            }
            case 2: {
                var b:Vec2 = vertices[1];
                var c:Vec2 = vertices[0];
                
                // line cb is the line formed by the first two vertices
                var cb:Vec2 = b - c;
                // line c0 is the line from the first vertex to the origin
                var c0:Vec2 = c * -1;

                // use the triple-cross-product to calculate a direction perpendicular
                // to line cb in the direction of the origin
                direction = tripleProduct(cb, c0, cb);
            }
            case 3: {
                // calculate if the simplex contains the origin
                var a:Vec2 = vertices[2];
                var b:Vec2 = vertices[1];
                var c:Vec2 = vertices[0];

                var a0:Vec2 = a * -1; // v2 to the origin
                var ab:Vec2 = b - a; // v2 to v1
                var ac:Vec2 = c - a; // v2 to v0

                var abPerp:Vec2 = tripleProduct(ac, ab, ab);
                var acPerp:Vec2 = tripleProduct(ab, ac, ac);

                if(abPerp.dot(a0) > 0) {
                    // the origin is outside line ab
                    // get rid of c and add a new support in the direction of abPerp
                    vertices.remove(c);
                    direction = abPerp;
                }
                else if(acPerp.dot(a0) > 0) {
                    // the origin is outside line ac
                    // get rid of b and add a new support in the direction of acPerp
                    vertices.remove(b);
                    direction = acPerp;
                }
                else {
                    // the origin is inside both ab and ac,
                    // so it must be inside the triangle!
                    return EvolveResult.FoundIntersection;
                }
            }
            case _: throw 'Can\'t have simplex with ${vertices.length} verts!';
        }

        return addSupport(direction)
            ? EvolveResult.StillEvolving
            : EvolveResult.NoIntersection;
    }

    public function test(shapeA:Shape2D, shapeB:Shape2D):Bool {
        // reset everything
        this.vertices = new Array<Vec2>();
        this.shapeA = shapeA;
        this.shapeB = shapeB;

        // do the actual test
        var result:EvolveResult = EvolveResult.StillEvolving;
        while(result == EvolveResult.StillEvolving) {
            result = evolveSimplex();
        }
        return result == EvolveResult.FoundIntersection;
    }

    private function findClosestEdge(winding:PolygonWinding):Edge {
        var closestDistance:Float = Math.POSITIVE_INFINITY;
        var closestNormal:Vec2 = new Vec2();
        var closestIndex:Int = 0;
        var line:Vec2 = new Vec2();
        for(i in 0...vertices.length) {
            var j:Int = i + 1;
            if(j >= vertices.length) j = 0;

            vertices[j].copy(line);
            line.subtractVec(vertices[i], line);

            var norm:Vec2 = switch(winding) {
                case PolygonWinding.Clockwise:
                    new Vec2(line.y, -line.x);
                case PolygonWinding.CounterClockwise:
                    new Vec2(-line.y, line.x);
                case _:
                    throw 'Invalid polygon winding!';
            }
            norm.normalize(norm);

            // calculate how far away the edge is from the origin
            var dist:Float = norm.dot(vertices[i]);
            if(dist < closestDistance) {
                closestDistance = dist;
                closestNormal = norm;
                closestIndex = j;
            }
        }

        return new Edge(closestDistance, closestNormal, closestIndex);
    }

    public function calculateIntersection():Vec2 {
        // first up: calculate the winding of the existing simplex
        var e0:Float = (vertices[1].x - vertices[0].x) * (vertices[1].y + vertices[0].y);
        var e1:Float = (vertices[2].x - vertices[1].x) * (vertices[2].y + vertices[1].y);
        var e2:Float = (vertices[0].x - vertices[2].x) * (vertices[0].y + vertices[2].y);
        var winding:PolygonWinding = (e0 + e1 + e2) >= 0 ? PolygonWinding.Clockwise : PolygonWinding.CounterClockwise;

        var intersection:Vec2 = new Vec2();
        for(i in 0...32) {
            var edge:Edge = findClosestEdge(winding);
            var support:Vec2 = calculateSupport(edge.normal);
            var distance:Float = support.dot(edge.normal);

            intersection = edge.normal.copy(intersection);
            intersection.multiplyScalar(distance, intersection);

            if(Math.abs(distance - edge.distance) <= 0.00001) {
                return intersection;
            }
            else {
                vertices.insert(edge.index, support);
            }
        }

        return intersection;
    }
}