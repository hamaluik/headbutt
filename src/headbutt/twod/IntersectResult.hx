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

import glm.Vec2;

/**
 The result of calculating the intersection between two shapes
**/
@:allow(headbutt.twod.Headbutt)
class IntersectResult {
    /**
     A vector describing the direction and magnitude of the overlap between the
     shapes
    **/
    public var intersection(default, null): Vec2;

    /**
     The same `shapeA` that was supplied to `test()`
    **/
    public var shapeA(default, null): Shape;

    /**
     The same `shapeB` that was supplied to `test()`
    **/
    public var shapeB(default, null): Shape;

    /**
     The normal of the collision, just a normalized version of `intersection`
    **/
    public var normal(default, null): Vec2;

    /**
     How much the two shapes are overlapping, just the magnitude of `intersection`
    **/
    public var overlapDistance(default, null): Float;

    // TODO: contact points

    function new(intersection: Vec2, shapeA: Shape, shapeB: Shape) {
        this.intersection = intersection;
        this.shapeA = shapeA;
        this.shapeB = shapeB;

        this.normal = Vec2.normalize(intersection, new Vec2());
        this.overlapDistance = intersection.length();

    }
}