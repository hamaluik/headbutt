/*
 * Apache License, Version 2.0
 *
 * Copyright (c) 2020 Kenton Hamaluik
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 *     http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package headbutt.twod;

import glm.Vec3;
import glm.Vec2;

private class Edge {
    public var distance: Float;
    public var normal: Vec2;
    public var index: Int;

    public function new(distance: Float, normal: Vec2, index: Int) {
        this.distance = distance;
        this.normal = normal;
        this.index = index;
    }
}

private enum EvolveResult {
    NoIntersection;
    FoundIntersection;
    StillEvolving;
}

private enum PolygonWinding {
    Clockwise;
    CounterClockwise;
}

typedef TestResult = {
    simplex: Array<Vec2>,
    colliding: Bool,
    shapeA: Shape,
    shapeB: Shape,
};

/**
 Implementations of the GJK and EPA algorithms
**/
class Headbutt {
    /**
       The maximum number of simplex evolution iterations before we accept the
       given simplex. For non-curvy shapes, this can be low. Curvy shapes potentially
       require higher numbers, but this can introduce significant slow-downs at
       the gain of not much accuracy.
    */
    public static var MAX_ITERATIONS: Int = 20;

    /**
     The maximum number of iterations to employ when running the EPA algoritm, usually
     required to be large-ish for circles
    **/
    public static var MAX_INTERSECTION_ITERATIONS: Int = 32;

    /**
     How accurate do intersection calculations need to be when using expanding polytopes
    **/
    public static var INTERSECTION_EPSILON: Float = 0.00000001;

    function new() {}

    static function calculateSupport(shapeA: Shape, shapeB: Shape, direction: Vec2): Vec2 {
        var oppositeDirection: Vec2 = Vec2.multiplyScalar(direction, -1, new Vec2());
        var newVertex: Vec2 = Vec2.copy(shapeA.support(direction), new Vec2());
        Vec2.subtractVec(newVertex, shapeB.support(oppositeDirection), newVertex);
        return newVertex;
    }

    static function addSupport(vertices: Array<Vec2>, shapeA: Shape, shapeB: Shape, direction: Vec2): Bool {
        var newVertex: Vec2 = calculateSupport(shapeA, shapeB, direction);
        vertices.push(newVertex);
        return Vec2.dot(direction, newVertex) >= 0;
    }

    static function tripleProduct(a: Vec2, b: Vec2, c: Vec2): Vec2 {
        var A: Vec3 = new Vec3(a.x, a.y, 0);
        var B: Vec3 = new Vec3(b.x, b.y, 0);
        var C: Vec3 = new Vec3(c.x, c.y, 0);

        var first: Vec3 = Vec3.cross(A, B, new Vec3());
        var second: Vec3 = Vec3.cross(first, C, new Vec3());

        return new Vec2(second.x, second.y);
    }

    static function evolveSimplex(vertices: Array<Vec2>, shapeA: Shape, shapeB: Shape, direction: Vec2): EvolveResult {
        switch(vertices.length) {
            case 0:  {
                Vec2.subtractVec(shapeB.centre, shapeA.centre, direction);
            }
            case 1:  {
                // flip the direction
                direction *= -1;
            }
            case 2:  {
                // line ab is the line formed by the first two vertices
                var ab: Vec2 = vertices[1] - vertices[0];
                // line a0 is the line from the first vertex to the origin
                var a0: Vec2 = vertices[0] * -1;

                // use the triple-cross-product to calculate a direction perpendicular
                // to line ab in the direction of the origin
                direction = tripleProduct(ab, a0, ab);
            }
            case 3:  {
                // calculate if the simplex contains the origin
                var c0: Vec2 = vertices[2] * -1;
                var bc: Vec2 = vertices[1] - vertices[2];
                var ca: Vec2 = vertices[0] - vertices[2];

                var bcNorm: Vec2 = tripleProduct(ca, bc, bc);
                var caNorm: Vec2 = tripleProduct(bc, ca, ca);

                if(Vec2.dot(bcNorm, c0) > 0) {
                    // the origin is outside line bc
                    // get rid of a and add a new support in the direction of bcNorm
                    vertices.remove(vertices[0]);
                    direction = bcNorm;
                }
                else if(Vec2.dot(caNorm, c0) > 0) {
                    // the origin is outside line ca
                    // get rid of b and add a new support in the direction of caNorm
                    vertices.remove(vertices[1]);
                    direction = caNorm;
                }
                else {
                    // the origin is inside both ab and ac,
                    // so it must be inside the triangle!
                    return EvolveResult.FoundIntersection;
                }
            }
            case _:  throw 'Can\'t have simplex with ${vertices.length} verts!';
        }

        return addSupport(vertices, shapeA, shapeB, direction)
            ? EvolveResult.StillEvolving
            :  EvolveResult.NoIntersection;
    }

    /**
       Given two convex shapes, test whether they overlap or not
       @param shapeA 
       @param shapeB 
       @return Bool
    */
    public static function test(shapeA: Shape, shapeB: Shape): TestResult {
        var vertices: Array<Vec2> = [];
        var direction: Vec2 = new Vec2();

        // do the actual test
        var result: EvolveResult = EvolveResult.StillEvolving;
        var iterations: Int = 0;
        while(iterations < MAX_ITERATIONS && result == EvolveResult.StillEvolving) {
            result = evolveSimplex(vertices, shapeA, shapeB, direction);
            iterations++;
        }
        return {
            simplex: vertices,
            colliding: result == EvolveResult.FoundIntersection,
            shapeA: shapeA,
            shapeB: shapeB,
        };
    }

    static function findClosestEdge(vertices: Array<Vec2>, winding: PolygonWinding): Edge {
        var closestDistance: Float = Math.POSITIVE_INFINITY;
        var closestNormal: Vec2 = new Vec2();
        var closestIndex: Int = 0;
        var line: Vec2 = new Vec2();
        for(i in 0...vertices.length) {
            var j: Int = i + 1;
            if(j >= vertices.length) j = 0;

            Vec2.copy(vertices[j], line);
            Vec2.subtractVec(line, vertices[i], line);

            var norm: Vec2 = switch(winding) {
                case PolygonWinding.Clockwise: 
                    new Vec2(line.y, -line.x);
                case PolygonWinding.CounterClockwise: 
                    new Vec2(-line.y, line.x);
            }
            Vec2.normalize(norm, norm);

            // calculate how far away the edge is from the origin
            var dist: Float = Vec2.dot(norm, vertices[i]);
            if(dist < closestDistance) {
                closestDistance = dist;
                closestNormal = norm;
                closestIndex = j;
            }
        }

        return new Edge(closestDistance, closestNormal, closestIndex);
    }

    /**
       Given two shapes, test whether they overlap or not. If they don't, returns
       `null`. If they do, calculates the penetration vector and returns it.
       @param testResult The return value from `test`
       @return Null<Vec2>
    */
    public static function intersect(testResult: TestResult): Null<Vec2> {
        if(!testResult.colliding) {
            // if we're not intersecting, return null
            return null;
        }

        // calculate the winding of the existing simplex
        var e0: Float = (testResult.simplex[1].x - testResult.simplex[0].x) * (testResult.simplex[1].y + testResult.simplex[0].y);
        var e1: Float = (testResult.simplex[2].x - testResult.simplex[1].x) * (testResult.simplex[2].y + testResult.simplex[1].y);
        var e2: Float = (testResult.simplex[0].x - testResult.simplex[2].x) * (testResult.simplex[0].y + testResult.simplex[2].y);
        var winding: PolygonWinding =
            if(e0 + e1 + e2 >= 0) PolygonWinding.Clockwise;
            else PolygonWinding.CounterClockwise;

        var intersection: Vec2 = new Vec2();
        for(_ in 0...MAX_INTERSECTION_ITERATIONS) {
            var edge: Edge = findClosestEdge(testResult.simplex, winding);
            var support: Vec2 = calculateSupport(testResult.shapeA, testResult.shapeB, edge.normal);
            var distance: Float = Vec2.dot(support, edge.normal);

            Vec2.copy(edge.normal, intersection);
            Vec2.multiplyScalar(intersection, distance, intersection);

            if(Math.abs(distance - edge.distance) <= INTERSECTION_EPSILON) {
                return intersection;
            }
            else {
                testResult.simplex.insert(edge.index, support);
            }
        }

        return intersection;
    }
}