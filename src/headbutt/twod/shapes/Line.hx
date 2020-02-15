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

package headbutt.twod.shapes;

using glm.Vec2;
import headbutt.twod.Shape;

/**
 Two points form a line in 2D
**/
class Line implements Shape {
    /**
     The centre of the line, really the midpoint
    **/
    public var centre(get, never): Vec2;
    function get_centre(): Vec2 {
        return new Vec2(
            (start.x + end.x) / 2,
            (start.y + end.y) / 2
        );
    }

    /**
       The first point of the line in global coordinates
    */
    public var start: Vec2;

    /**
       The second point of the line in global coordinates
    */
    public var end: Vec2;

    /**
     Create a new line segment from start to end
     @param start one end of the line
     @param end the other end of the line
    **/
    public function new(start: Vec2, end: Vec2) {
        this.start = start;
        this.end = end;
    }

    /**
       Given a direction in global coordinates, return the vertex (in global coordinates)
       that is the furthest in that direction
       @param direction the direction to check
       @return Vec2
    */
    public function support(direction: Vec2): Vec2 {
        if(Vec2.dot(start, direction) > Vec2.dot(end, direction)) {
            return start;
        }
        else {
            return end;
        }
    }
}