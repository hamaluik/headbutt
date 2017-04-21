package shapes;

import headbutt.shapes.Circle;
import buddy.*;
using buddy.Should;
import glm.Vec2;

class TestCircle extends BuddySuite {
    public function new() {
        describe('Using circles', {
            it('should calculate the center', {
                var circ:Circle = new Circle(new Vec2(0, 0.5), 0.75);
                var c:Vec2 = circ.center();

                c.x.should.be(0);
                c.y.should.be(0.5);
            });

            it('should calculate supports when at the origin', {
                var direction:Vec2 = new Vec2(1, 0);
                var circ:Circle = new Circle(new Vec2(0, 0), 1);

                var support:Vec2 = circ.support(direction);
                support.x.should.be(1);
                support.y.should.be(0);

                direction.y = 1;
                support = circ.support(direction);
                support.x.should.beCloseTo(Math.sqrt(2.0)/2.0);
                support.y.should.beCloseTo(Math.sqrt(2.0)/2.0);
            });

            it('should calculate supports when not at the origin', {
                var circ:Circle = new Circle(new Vec2(2, 4), 1);
                var direction:Vec2 = new Vec2(0, 1);

                var support:Vec2 = circ.support(direction);
                support.x.should.be(2);
                support.y.should.be(5);
            });
        });
    }
}