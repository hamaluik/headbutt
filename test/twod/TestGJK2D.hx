package twod;

import headbutt.twod.GJK2D;
import headbutt.shapes.Circle;
import buddy.*;
using buddy.Should;
import glm.Vec2;

@:privateAccess(headbutt.twod.GJK2D)
class TestGJK2D extends BuddySuite {
    public function new() {
        describe('Using circles', {
            var gjk:GJK2D;
            beforeEach({
                gjk = new GJK2D();
            });

            it('should calculate Minkowski difference supports');
        });
    }
}