import headbutt.Headbutt2D;
import headbutt.shapes.Polygon2D;
import headbutt.shapes.Circle;
import buddy.*;
using buddy.Should;
import glm.Vec2;

@:access(headbutt.Headbutt2D)
class TestHeadbutt2D extends BuddySuite {
    public function new() {
        describe('Using Headbutt2D', {
            var hb:Headbutt2D;
            beforeEach({
                hb = new Headbutt2D();
            });

            it('should calculate Minkowski difference supports with polygons', {
                var shapeA:Polygon2D = new Polygon2D([
                    new Vec2(-18, -18), new Vec2(-10, -18),
                    new Vec2(-10, -13), new Vec2(-18, -13)
                ]);
                var shapeB:Polygon2D = new Polygon2D([
                    new Vec2(-14, -14), new Vec2(-5, -16), new Vec2(-12, -8)
                ]);

                hb.shapeA = shapeA;
                hb.shapeB = shapeB;

                var verts:Array<Vec2> = new Array<Vec2>();
                for(a in shapeA.vertices) {
                    for(b in shapeB.vertices) {
                        verts.push(new Vec2(a.x - b.x, a.y - b.y));
                    }
                }
                var md:Polygon2D = new Polygon2D(verts);
                
                var dirs:Array<Vec2> = [
                    new Vec2(-1, 1), new Vec2(0, 1), new Vec2(1, 1),
                    new Vec2(-1, 0), new Vec2(1, 0),
                    new Vec2(-1, -1), new Vec2(0, -1), new Vec2(1, -1)
                ];
                for(dir in dirs) {
                    var mdSupport:Vec2 = md.support(dir);
                    var support:Vec2 = hb.calculateSupport(dir);
                    support.x.should.be(mdSupport.x);
                    support.y.should.be(mdSupport.y);
                }
            });

            it('should detect collisions for two polygons which overlap', {
                var shapeA:Polygon2D = new Polygon2D([
                    new Vec2(-18, -18), new Vec2(-10, -18),
                    new Vec2(-10, -13), new Vec2(-18, -13)
                ]);
                var shapeB:Polygon2D = new Polygon2D([
                    new Vec2(-14, -14), new Vec2(-5, -16), new Vec2(-12, -8)
                ]);

                var result:Bool = hb.test(shapeA, shapeB);
                result.should.be(true);
            });

            it('shouldn\'t detect collisions for two polygons which don\'t overlap', {
                var shapeA:Polygon2D = new Polygon2D([
                    new Vec2(-18, -18), new Vec2(-10, -18),
                    new Vec2(-10, -13), new Vec2(-18, -13)
                ]);
                var shapeB:Polygon2D = new Polygon2D([
                    new Vec2(-9, -14), new Vec2(0, -16), new Vec2(-7, -8)
                ]);

                var result:Bool = hb.test(shapeA, shapeB);
                result.should.be(false);
            });

            it('shouldn\'t matter what order the polygons go in', {
                var shapeA:Polygon2D = new Polygon2D([
                    new Vec2(-18, -18), new Vec2(-10, -18),
                    new Vec2(-10, -13), new Vec2(-18, -13)
                ]);
                var shapeB:Polygon2D = new Polygon2D([
                    new Vec2(-14, -14), new Vec2(-5, -16), new Vec2(-12, -8)
                ]);

                var resultA:Bool = hb.test(shapeA, shapeB);
                var resultB:Bool = hb.test(shapeB, shapeA);
                resultA.should.be(true);
                resultB.should.be(true);
            });

            it('should detect collisions between a shape and itself', {
                var shapeA:Polygon2D = new Polygon2D([
                    new Vec2(-18, -18), new Vec2(-10, -18),
                    new Vec2(-10, -13), new Vec2(-18, -13)
                ]);
                var result:Bool = hb.test(shapeA, shapeA);
                result.should.be(true);
            });

            it('should detect collisions between two lines', {
                var lineA:Polygon2D = new Polygon2D([
                    new Vec2(-1, -1), new Vec2(1, 1)
                ]);
                var lineB:Polygon2D = new Polygon2D([
                    new Vec2(-1, 1), new Vec2(1, -1)
                ]);

                var result:Bool = hb.test(lineA, lineB);
                result.should.be(true);
            });

            it('should detect collisions between a line and a polygon', {
                var shapeA:Polygon2D = new Polygon2D([
                    new Vec2(-1, -1), new Vec2(1, -1),
                    new Vec2(1, 1), new Vec2(-1, 1)
                ]);
                var lineA:Polygon2D = new Polygon2D([
                    new Vec2(-1, -1), new Vec2(1, 1)
                ]);

                var result:Bool = hb.test(shapeA, lineA);
                result.should.be(true);
            });

            it('should detect collisions between a line and a circle', {
                var circ:Circle = new Circle(new Vec2(0, 0), 1);
                var lineA:Polygon2D = new Polygon2D([
                    new Vec2(-1, -1), new Vec2(1, 1)
                ]);
                var lineB:Polygon2D = new Polygon2D([
                    new Vec2(-5, -5), new Vec2(-5, 5)
                ]);

                var resultA:Bool = hb.test(circ, lineA);
                var resultB:Bool = hb.test(circ, lineB);

                resultA.should.be(true);
                resultB.should.be(false);
            });

            it('should detect collisions between a polygon and a circle', {
                var circ:Circle = new Circle(new Vec2(0.25, 0), 1);
                var square:Polygon2D = new Polygon2D([
                    new Vec2(-1, -1), new Vec2(1, -1),
                    new Vec2(1, 1), new Vec2(-1, 1)
                ]);

                var result:Bool = hb.test(circ, square);
                result.should.be(true);
            });

            it('should calculate the intersection of two boxes', {
                var squareA:Polygon2D = new Polygon2D([
                    new Vec2(-1, -1), new Vec2(1, -1),
                    new Vec2(1, 1), new Vec2(-1, 1)
                ]);
                var squareB:Polygon2D = new Polygon2D([
                    new Vec2(0.25, -2.75), new Vec2(2.75, -2.75),
                    new Vec2(2.75, -0.75), new Vec2(0.25, -0.75)
                ]);

                var intersection:Vec2 = hb.intersect(squareA, squareB);
                intersection.x.should.beCloseTo(0);
                intersection.y.should.beCloseTo(-0.25);
            });

            it('should calculate the intersection of two circles', {
                var circA:Circle = new Circle(new Vec2(0, 0), 1);
                var circB:Circle = new Circle(new Vec2(1, 1), 0.5);
                
                var intersection:Vec2 = hb.intersect(circA, circB);

                // calculate the intersection manually
                var ix:Float = circA.radius * Math.cos(Math.PI / 4) - (circB.radius * Math.cos(5 * Math.PI / 4) + circB.centre.x);
                var iy:Float = circA.radius * Math.sin(Math.PI / 4) - (circB.radius * Math.sin(5 * Math.PI / 4) + circB.centre.y);
                intersection.x.should.beCloseTo(ix);
                intersection.y.should.beCloseTo(iy);
            });

            it('should calculate the intersection of a line and square', {
                var square:Polygon2D = new Polygon2D([
                    new Vec2(-1, -1), new Vec2(1, -1),
                    new Vec2(1, 1), new Vec2(-1, 1)
                ]);
                var line:Polygon2D = new Polygon2D([
                    new Vec2(0.5, 0), new Vec2(3, 3)
                ]);

                var intersection:Vec2 = hb.intersect(square, line);
                intersection.x.should.be(0.5);
                intersection.y.should.be(0);
            });

            it('should calculate the intersection of two polygons', {
                var pa:Polygon2D = new Polygon2D([
                    new Vec2(4, 11), new Vec2(9, 9), new Vec2(4, 5)
                ]);
                var pb:Polygon2D = new Polygon2D([
                    new Vec2(5, 7), new Vec2(12, 7),
                    new Vec2(10, 2), new Vec2(7, 3)
                ]);

                var intersection:Vec2 = hb.intersect(pa, pb);
                var length:Float = intersection.length();
                Vec2.normalize(intersection, intersection);

                intersection.x.should.beCloseTo(0.62);
                intersection.y.should.beCloseTo(-0.78);
                length.should.beCloseTo(0.94);
            });
        });
    }
}