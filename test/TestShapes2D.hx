import glm.Mat4;
import glm.Quat;
import headbutt.twod.shapes.Circle;
import headbutt.twod.shapes.Polygon;
import headbutt.twod.shapes.Rectangle;
import buddy.*;
using buddy.Should;
import glm.Vec2;

@:access(headbutt.threed.Headbutt)
class TestShapes2D extends BuddySuite {
    public function new() {
        describe('Using A Polygon', {
            var p: Polygon;
            beforeEach({
                p = new Polygon([
                    new Vec2(-1, -1),
                    new Vec2( 1, -1),
                    new Vec2( 0,  1),
                ]);
            });

            it('should calculate moved centres when transformed', {
                p.set_trs(new Vec2(0, 3), 0, new Vec2(1, 1));
                var c: Vec2 = p.centre;
                c.x.should.beCloseTo(0);
                c.y.should.beCloseTo(3);
            });

            it('should calculate support vertices when untransformed', {
                var support: Vec2 = p.support(new Vec2(0, 1));
                support.x.should.beCloseTo(0);
                support.y.should.beCloseTo(1);

                var support: Vec2 = p.support(new Vec2(-0.5, 1));
                support.x.should.beCloseTo(0);
                support.y.should.beCloseTo(1);
            });

            it('should calculate support vertices when translated', {
                p.set_trs(new Vec2(0, 3), 0, new Vec2(1, 1));
                
                var support: Vec2 = p.support(new Vec2(0, 1));
                support.x.should.beCloseTo(0);
                support.y.should.beCloseTo(4);
            });

            it('should calculate support vertices when rotated', {
                p.set_trs(new Vec2(0, 0), Math.PI / 2, new Vec2(1, 1));
                
                var support: Vec2 = p.support(new Vec2(-1, 0));
                support.x.should.beCloseTo(-1);
                support.y.should.beCloseTo(0);
            });
        });

        describe('Using A Rectangle', {
            var r: Rectangle;
            beforeEach({
                r = new Rectangle(new Vec2(0.5, 0.5));
            });

            it('should calculate moved centres when transformed', {
                r.set_trs(new Vec2(0, 3), 0, new Vec2(1, 1));
                var c: Vec2 = r.centre;
                c.x.should.beCloseTo(0);
                c.y.should.beCloseTo(3);
            });

            it('should calculate support vertices when untransformed', {
                var support: Vec2 = r.support(new Vec2(1, 1));
                support.x.should.beCloseTo(0.5);
                support.y.should.beCloseTo(0.5);
            });

            it('should calculate support vertices when translated', {
                r.set_trs(new Vec2(0, 3), 0, new Vec2(1, 1));
                
                var support: Vec2 = r.support(new Vec2(1, 1));
                support.x.should.beCloseTo(0.5);
                support.y.should.beCloseTo(3.5);
            });

            it('should calculate support vertices when rotated', {
                r.set_trs(new Vec2(0, 0), Math.PI / 4, new Vec2(1, 1));
                
                var support: Vec2 = r.support(new Vec2(0, 1));
                support.x.should.beCloseTo(0.0);
                support.y.should.beCloseTo(1 / Math.sqrt(2));
            });
        });

        describe('Using A Circle', {
            var c: Circle;
            beforeEach({
                c = new Circle(new Vec2(0, 0), 1);
            });

            it('should calculate moved centres when transformed', {
                c.position = new Vec2(4, 1);
                var c: Vec2 = c.centre;
                c.x.should.beCloseTo(4);
                c.y.should.beCloseTo(1);
            });

            it('should calculate support vertices when untransformed', {
                var support: Vec2 = c.support(new Vec2(1, 1));
                support.x.should.beCloseTo(1 / Math.sqrt(2));
                support.y.should.beCloseTo(1 / Math.sqrt(2));
            });

            it('should calculate support vertices when translated', {
                c.position.x = 3;
                
                var support: Vec2 = c.support(new Vec2(1, 1));
                support.x.should.beCloseTo(1 / Math.sqrt(2) + 3);
                support.y.should.beCloseTo(1 / Math.sqrt(2));
            });
        });
    }
}