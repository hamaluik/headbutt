import headbutt.twod.IntersectResult;
import glm.Vec3;
import glm.Mat3;
import headbutt.twod.Headbutt;
import headbutt.twod.shapes.Polygon;
import headbutt.twod.shapes.Circle;
import headbutt.twod.shapes.Line;
import headbutt.twod.shapes.Rectangle;
import buddy.*;
using buddy.Should;
import glm.Vec2;

@:access(headbutt.twod.Headbutt)
class TestHeadbutt2D extends BuddySuite {
    public function new() {
        describe('Using Headbutt 2D', {
            it('should calculate Minkowski difference supports with polygons', {
                var shapeA: Polygon = new Polygon([
                    new Vec2(-1,  1), new Vec2( 1,  1),
                    new Vec2(-1, -1), new Vec2( 1, -1)
                ]);
                var shapeB: Polygon = new Polygon([
                    new Vec2(-1,  1), new Vec2( 1,  1),
                    new Vec2(-1, -1), new Vec2( 1, -1)
                ]);

                var verts: Array<Vec2> = new Array<Vec2>();
                for(a in shapeA.vertices) {
                    for(b in shapeB.vertices) {
                        verts.push(new Vec2(a.x - b.x, a.y - b.y));
                    }
                }
                var md: Polygon = new Polygon(verts);
                
                var dirs: Array<Vec2> = [
                    new Vec2(-1, 1), new Vec2(0, 1), new Vec2(1, 1),
                    new Vec2(-1, 0), new Vec2(1, 0),
                    new Vec2(-1, -1), new Vec2(0, -1), new Vec2(1, -1)
                ];
                for(dir in dirs) {
                    var mdSupport: Vec2 = md.support(dir);
                    var support: Vec2 = Headbutt.calculateSupport(shapeA, shapeB, dir);
                    support.x.should.be(mdSupport.x);
                    support.y.should.be(mdSupport.y);
                }
            });

            it('should detect collisions for two polygons which overlap', {
                var shapeA: Polygon = new Polygon([
                    new Vec2(-1,  1), new Vec2( 1,  1),
                    new Vec2(-1, -1), new Vec2( 1, -1)
                ]);
                var shapeB: Polygon = new Polygon([
                    new Vec2(-1,  1), new Vec2( 1,  1),
                    new Vec2(-1, -1), new Vec2( 1, -1)
                ]);
                shapeB.setTransform(new Vec2(0.5, 0.5), 0, new Vec2(1, 1));

                var result: Bool = Headbutt.test(shapeA, shapeB);
                result.should.be(true);
            });

            it('shouldn\'t detect collisions for two polygons which don\'t overlap', {
                var shapeA: Polygon = new Polygon([
                    new Vec2(-1,  1), new Vec2( 1,  1),
                    new Vec2(-1, -1), new Vec2( 1, -1)
                ]);
                var shapeB: Polygon = new Polygon([
                    new Vec2(-1,  1), new Vec2( 1,  1),
                    new Vec2(-1, -1), new Vec2( 1, -1)
                ]);
                shapeB.setTransform(new Vec2(5, 0), 0, new Vec2(1, 1));

                var result: Bool = Headbutt.test(shapeA, shapeB);
                result.should.be(false);
            });

            it('shouldn\'t matter what order the polygons go in', {
                var shapeA: Polygon = new Polygon([
                    new Vec2(-1,  1), new Vec2( 1,  1),
                    new Vec2(-1, -1), new Vec2( 1, -1)
                ]);
                var shapeB: Polygon = new Polygon([
                    new Vec2(-1,  1), new Vec2( 1,  1),
                    new Vec2(-1, -1), new Vec2( 1, -1)
                ]);
                shapeB.setTransform(new Vec2(0.5, 0.5), 0, new Vec2(1, 1));

                var resultA: Bool = Headbutt.test(shapeA, shapeB);
                var resultB: Bool = Headbutt.test(shapeB, shapeA);
                resultA.should.be(true);
                resultB.should.be(true);
            });

            it('should detect collisions between a shape and itself', {
                var shapeA: Polygon = new Polygon([
                    new Vec2(-1,  1), new Vec2( 1,  1),
                    new Vec2(-1, -1), new Vec2( 1, -1)
                ]);
                var result: Bool = Headbutt.test(shapeA, shapeA);
                result.should.be(true);
            });

            it('should detect collisions between two lines', {
                var lineA = new Line(new Vec2(-1, -1), new Vec2(1, 1));
                var lineB = new Line(new Vec2(-1, 1), new Vec2(1, -1));

                var result: Bool = Headbutt.test(lineA, lineA);
                result.should.be(true);
            });

            it('should detect collisions between a line and a polygon', {
                var shapeA: Polygon = new Polygon([
                    new Vec2(-1, -1), new Vec2(1, -1),
                    new Vec2(1, 1), new Vec2(-1, 1)
                ]);
                var lineA = new Line(new Vec2(-1, -1), new Vec2(1, 1));

                var result: Bool = Headbutt.test(shapeA, lineA);
                result.should.be(true);
            });

            it('should detect collisions between a line and a circle', {
                var circ: Circle = new Circle(new Vec2(0, 0), 1);
                var lineA = new Line(new Vec2(-1, -1), new Vec2(1, 1));
                var lineB = new Line(new Vec2(-5, -5), new Vec2(-4, -4));

                var resultA: Bool = Headbutt.test(circ, lineA);
                var resultB: Bool = Headbutt.test(circ, lineB);

                resultA.should.be(true);
                resultB.should.be(false);
            });

            it('should detect collisions between a polygon and a circle', {
                var circ: Circle = new Circle(new Vec2(0.25, 0), 1);
                var square: Polygon = new Polygon([
                    new Vec2(-1, -1), new Vec2(1, -1),
                    new Vec2(1, 1), new Vec2(-1, 1)
                ]);

                var result: Bool = Headbutt.test(circ, square);
                result.should.be(true);
            });

            it('should calculate the intersection of two rectangles', {
                var squareA: Rectangle = new Rectangle(new Vec2(2, 2));
                var squareB: Rectangle = new Rectangle(new Vec2(2, 2));
                squareB.setTransform(new Vec2(1.5, 0), 0, new Vec2(1, 1));

                var result: Null<IntersectResult> = Headbutt.intersect(Headbutt.test(squareA, squareB));
                result.should.not.be(null);
                result.intersection.x.should.beCloseTo(0.5);
                result.intersection.y.should.beCloseTo(0);
            });

            it('should calculate the intersection of two circles', {
                var circA: Circle = new Circle(new Vec2(0, 0), 1);
                var circB: Circle = new Circle(new Vec2(1, 1), 0.5);
                
                var result: Null<IntersectResult> = Headbutt.intersect(Headbutt.test(circA, circB));

                // calculate the intersection manually
                var ix: Float = circA.radius * Math.cos(Math.PI / 4) - (circB.radius * Math.cos(5 * Math.PI / 4) + circB.centre.x);
                var iy: Float = circA.radius * Math.sin(Math.PI / 4) - (circB.radius * Math.sin(5 * Math.PI / 4) + circB.centre.y);
                result.intersection.x.should.beCloseTo(ix);
                result.intersection.y.should.beCloseTo(iy);
            });

            it('should calculate the intersection of a line and square', {
                var square: Rectangle = new Rectangle(new Vec2(2, 2));
                var line: Line = new Line(new Vec2(0.5, 0), new Vec2(3.5, 3));

                var result: Null<IntersectResult> = Headbutt.intersect(Headbutt.test(square, line));
                result.intersection.x.should.be(0.5);
                result.intersection.y.should.be(0);
            });

            it('should collide between a rotated square and a not', {
                var squareA: Rectangle = new Rectangle(new Vec2(2, 2));
                var squareB: Rectangle = new Rectangle(new Vec2(2, 2));

                squareB.setTransform(new Vec2(2.1, 0), 0, new Vec2(1, 1));
                var hit: Bool = Headbutt.test(squareA, squareB).colliding;
                hit.should.be(false);

                squareB.setTransform(new Vec2(2.1, 0), Math.PI / 4, new Vec2(1, 1));
                var hit: Bool = Headbutt.test(squareA, squareB).colliding;
                hit.should.be(true);

                squareB.setTransform(new Vec2(2.1, 0), 0, new Vec2(1.5, 1));
                var hit: Bool = Headbutt.test(squareA, squareB).colliding;
                hit.should.be(true);
            });
        });
    }
}