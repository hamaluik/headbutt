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

package headbutt.threed;

import glm.Vec3;

@:allow(headbutt.threed.TestResult)
@:allow(headbutt.threed.Headbutt)
private class _TestResult {
    /**
     Whether or not the two tested shapes are colliding
    **/
    public var colliding(default, null): Bool;

    
    public var simplex(default, null): Array<Vec3>;
    public var shapeA(default, null): Shape;
    public var shapeB(default, null): Shape;

    function new(colliding: Bool, simplex: Array<Vec3>, shapeA: Shape, shapeB: Shape) {
        this.colliding = colliding;
        this.simplex = simplex;
        this.shapeA = shapeA;
        this.shapeB = shapeB;
    }
}

/**
 The result of a collision test, which can be coerced into a `Bool` for easy
 collision checking, or fed into `Headbutt.intersect` to calculate penetration
 vectors
**/
@:allow(headbutt.threed.Headbutt)
@:forward
abstract TestResult(_TestResult) {
    function new(colliding: Bool, simplex: Array<Vec3>, shapeA: Shape, shapeB: Shape) {
        this = new _TestResult(colliding, simplex, shapeA, shapeB);
    }

    @:to
    function toBool(): Bool {
        return this.colliding;
    }
}